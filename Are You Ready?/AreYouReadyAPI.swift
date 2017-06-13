//
//  AreYouReadyAPI.swift
//  Are You Ready?
//
//  Created by Markus Tran on 5/17/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

enum APIError: Error {
    case requestFailure(String)
    case JSONParseFailure(String)
}

enum APIResult<Type> {
    case success(Type)
    case failure(APIError)
}

// Change this URL to change where API requests are sent. Change it to "http://localhost:3000" to use your local server, but localhost will not work if your build target is an iOS device (not an iOS Simulator). In that case, use the internal IP address (eg. "http://192.168.1.62:3000"). Please do not commit this line as anything other than "http://ayr.pf-n.co".
// TODO: Determine API URL based on build settings. (development vs production)
let BASE_API_URL = URL(string: "http://ayr.pf-n.co")!

let session = URLSession.shared

func jsonGet(_ endpoint: String, completionHandler: @escaping (Any?, APIError?) -> Void) {
    let urlRequest = URLRequest(url: URL(string: endpoint, relativeTo: BASE_API_URL)!)
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
        // If `error` is `nil`, then there was a problem making the request (eg. No internet, Could not find host)
        guard error == nil else {
            completionHandler(nil, .requestFailure(error!.localizedDescription))
            return
        }
        
        // If somehow `response` or `data` is `nil`, then I'm not sure what happened
        guard let response = response, let data = data else {
            completionHandler(nil, .requestFailure("Bad response: No data"))
            return
        }
        
        // If `statusCode` was not `200`, then we did not get what we wanted (eg. 404 - Not Found, 500 - Internal Server Error)
        let statusCode = (response as! HTTPURLResponse).statusCode
        if statusCode != 200 {
            let status = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            completionHandler(nil, .requestFailure("Bad response: \(statusCode) - \(status)"))
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
     Gets the user profile.
     
     ```swift
     AreYouReadyAPI.getProfile(name: "Markus") { (result) in
        switch (result) {
        case let .success(profile):
            print(profile.name)
            print(profile.age)
        case let .failure(.requestFailure(reason)),
             let .failure(.JSONParseFailure(reason)):
            print("Request failed because \(reason)")
        }
     }
     ```
     
     - Parameters:
        - name: The *name* to query.
        - completionHandler: The completion handler to call when the request is complete. The completion handler takes a single parameter `result`.
     */
    static func getProfile(name: String, completionHandler: @escaping (APIResult<AYRUserProfile>) -> Void) {
        let name = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        jsonGet("/profile/\(name)") { (json, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let json = json as? [String: Any],
                let name = json["name"] as? String,
                let age = json["age"] as? Int
            else {
                completionHandler(.failure(.JSONParseFailure("Could not convert JSON to AYRUserProfile")))
                return
            }

            let profile = AYRUserProfile(name: name, age: age)
            completionHandler(.success(profile))
        }
    }
}
