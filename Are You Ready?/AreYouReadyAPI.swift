//
//  AreYouReadyAPI.swift
//  Are You Ready?
//
//  Created by Markus Tran on 5/17/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

enum APIError: Error {
    /// (reason, statusCode) Could not make a request, or did not receive a 200
    case requestFailure(String, Int?)
    /// (reason) Received a response, but it was not JSON or was not of an expected JSON structure
    case JSONParseFailure(String)
    /// (reason, errorCode) API responded successfully with an error (e.g. "User not found")
    case JSONErrorResponse(String, Int?)
}

enum APIResult<Type> {
    case success(Type)
    case failure(APIError)
}

// Change this URL to change where API requests are sent. Change it to "http://localhost:3000" to use your local server, but localhost will not work if your build target is an iOS device (not an iOS Simulator). In that case, use the internal IP address (eg. "http://192.168.1.62:3000"). Please do not commit this line as anything other than "http://ayr.pf-n.co".
let BASE_API_URL = URL(string: "http://ayr.pf-n.co")!
let GROUP_NAME = "cis55"

let session = URLSession.shared

func jsonGet(_ endpoint: String, completionHandler: @escaping (Any?, APIError?) -> Void) {
    let urlRequest = URLRequest(url: URL(string: endpoint, relativeTo: BASE_API_URL)!)
    let task = session.dataTask(with: urlRequest) { data, response, error in
        // If `error` is `nil`, then there was a problem making the request (eg. No internet, Could not find host)
        guard error == nil else {
            completionHandler(nil, .requestFailure(error!.localizedDescription, nil))
            return
        }
        
        // If somehow `response` or `data` is `nil`, then I'm not sure what happened
        guard let response = response, let data = data else {
            completionHandler(nil, .requestFailure("Bad response: No data", nil))
            return
        }
        
        // If `statusCode` was not `200`, then we did not get what we wanted (eg. 404 - Not Found, 500 - Internal Server Error)
        let statusCode = (response as! HTTPURLResponse).statusCode
        if statusCode >= 400 {
            let status = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            completionHandler(nil, .requestFailure("Bad response: \(status)", statusCode))
            return
        }
        
        // We got a response. Try to parse it as JSON
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            completionHandler(json, nil)
        } catch {
            completionHandler(nil, .JSONParseFailure(error.localizedDescription))
        }
    }
    task.resume()
}

func jsonPost(_ endpoint: String, body: Any, completionHandler: @escaping (Any?, APIError?) -> Void) {
    let jsonData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    
    var urlRequest = URLRequest(url: URL(string: endpoint, relativeTo: BASE_API_URL)!)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    urlRequest.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        // If `error` is `nil`, then there was a problem making the request (eg. No internet, Could not find host)
        guard error == nil else {
            completionHandler(nil, .requestFailure(error!.localizedDescription, nil))
            return
        }
        
        // If somehow `response` or `data` is `nil`, then I'm not sure what happened
        guard let response = response, let data = data else {
            completionHandler(nil, .requestFailure("Bad response: No data", nil))
            return
        }
        
        // If `statusCode` was not `200`, then we did not get what we wanted (eg. 404 - Not Found, 500 - Internal Server Error)
        let statusCode = (response as! HTTPURLResponse).statusCode
        if statusCode != 200 {
            let status = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            completionHandler(nil, .requestFailure("Bad response: \(status)", statusCode))
            return
        }
        
        // We got a response. Try to parse it as JSON
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            completionHandler(json, nil)
        } catch {
            completionHandler(nil, .JSONParseFailure(error.localizedDescription))
        }
    }
    task.resume()
}

class AreYouReadyAPI {
    /**
     Gets the group. (This should be all you need).
     
     ```swift
     AreYouReadyAPI.getGroup("cis55") { result in
        switch (result) {
        case let .success(group):
            print(group.name)
        case let .failure(.requestFailure(reason, _)),
             let .failure(.JSONParseFailure(reason)),
             let .failure(.JSONErrorResponse(reason, _)):
            print("Request failed because: \(reason)")
        }
     }
     ```
     
     - Parameters:
        - groupName: The *name* of the group to query.
        - completionHandler: The completion handler to call when the request is complete. The completion handler takes a single parameter `result`.
     */
    static func getGroup(_ groupName: String, completionHandler: @escaping (APIResult<AYRGroup>) -> Void) {
        let groupName = GROUP_NAME.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!

        jsonGet("/api/group/\(groupName)") { json, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let jsonError = AYRJsonError(fromJSON: json) {
                completionHandler(.failure(.JSONErrorResponse(jsonError.description, jsonError.code)))
                return
            }
            
            if let group = AYRGroup(fromJSON: json) {
                completionHandler(.success(group))
            } else {
                completionHandler(.failure(.JSONParseFailure("Could not convert JSON to AYRGroup")))
            }
        }
    }
    
    /**
     Sample endpoint for using POST. You don't need to use this method
     */
    static func createUser(_ userName: String, inGroup groupName: String, completionHandler: @escaping (APIResult<AYRGroup>) -> Void) {
        let json: [String: Any] = ["userName": userName]
        let groupName = GROUP_NAME.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!

        jsonPost("/api/group/\(groupName)/users", body: json) { json, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let jsonError = AYRJsonError(fromJSON: json) {
                completionHandler(.failure(.JSONErrorResponse(jsonError.description, jsonError.code)))
                return
            }
            
            if let group = AYRGroup(fromJSON: json) {
                completionHandler(.success(group))
            } else {
                completionHandler(.failure(.JSONParseFailure("Could not convert JSON to AYRGroup")))
            }
        }
    }
    
    /**
     Create an event for group.
     
     ```swift
     let event = AYREvent(
         name: "Awesome Event",
         type: .eatOut,
         description: "Let's go do stuff",
         location: "Somewhere far, far away",
         meetupLocation: .car,
         createdBy: AYRUser(name: "Markus"),
         createdAt: Date(), // This value will be replaced by the server anyway
         notificationTime: Date(timeIntervalSinceNow: 300),
         readyTime: Date(timeIntervalSinceNow: 600),
         attendees: [:]     // This value will also be auto-populated by the server
     )
     
     AreYouReadyAPI.createEvent(event, inGroup: "cis55") { result in
         switch (result) {
         case let .success(group):
             print(group.name)
         case let .failure(.requestFailure(reason, _)),
              let .failure(.JSONParseFailure(reason)),
              let .failure(.JSONErrorResponse(reason, _)):
             print("Request failed because: \(reason)")
         }
     }
     ```
     
     - Parameters:
     - event: The event to create. Note that `createdAt` and `attendees` are ignored.
     - groupName: The gr
     - completionHandler: The completion handler to call when the request is complete. The completion handler takes a single parameter `result`.
     */
    static func createEvent(_ event: AYREvent, inGroup groupName: String, completionHandler: @escaping (APIResult<AYRGroup>) -> Void) {
        let json: [String: Any] = [
            "name": event.name,
            "type": event.type!.rawValue,
            "description": event.description,
            "location": event.location,
            "meetupLocation": event.meetupLocation!.rawValue,
            "createdBy": event.createdBy.name,
            "notificationTime": event.notificationTime.timeIntervalSince1970 * 1000,
            "readyTime": event.readyTime.timeIntervalSince1970 * 1000
        ]
        let groupName = GROUP_NAME.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!

        jsonPost("/api/group/\(groupName)/events", body: json) { json, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let jsonError = AYRJsonError(fromJSON: json) {
                completionHandler(.failure(.JSONErrorResponse(jsonError.description, jsonError.code)))
                return
            }
            
            if let group = AYRGroup(fromJSON: json) {
                completionHandler(.success(group))
            } else {
                completionHandler(.failure(.JSONParseFailure("Could not convert JSON to AYRGroup")))
            }
        }
    }
    
    /**
     Set someone's status for an event in a group.
     
     ```swift
     AreYouReadyAPI.updateStatus(group: "cis55", event: "Awesome Event", user: "Markus", status: .notComing) { result in
         switch (result) {
         case let .success(group):
             print(group.name)
         case let .failure(.requestFailure(reason, _)),
              let .failure(.JSONParseFailure(reason)),
              let .failure(.JSONErrorResponse(reason, _)):
             print("Request failed because: \(reason)")
         }
     }
     ```
     
     - Parameters:
     - groupName: The name of the group to update.
     - eventName: The name of the event to update.
     - userName: The name of the user to update status for.
     - status: The status to change to.
     - completionHandler: The completion handler to call when the request is complete. The completion handler takes a single parameter `result`.
     */
    static func updateStatus(group groupName: String, event eventName: String, user userName: String, status: AttendeeStatus, completionHandler: @escaping (APIResult<AYRGroup>) -> Void) {
        let json: [String: Any] = [
            "userName": userName,
            "eventStatus": status.rawValue
        ]
        let groupName = GROUP_NAME.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let eventName = eventName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        
        jsonPost("/api/group/\(groupName)/event/\(eventName)/status", body: json) { json, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            if let jsonError = AYRJsonError(fromJSON: json) {
                completionHandler(.failure(.JSONErrorResponse(jsonError.description, jsonError.code)))
                return
            }
            
            if let group = AYRGroup(fromJSON: json) {
                completionHandler(.success(group))
            } else {
                completionHandler(.failure(.JSONParseFailure("Could not convert JSON to AYRGroup")))
            }
        }
    }
}
