//
//  AYREvent.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/5/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import Foundation

enum EventType: String {
    case eatOut, hangOut, meetUp
}
enum EventMeetupLocation: String {
    case car, frontDoor, kitchen, livingRoom
}
enum AttendeeStatus: String {
    case pending, coming, notComing = "not-coming", ready, notReady = "not-ready"
}

func parseISODate(_ ISOString: String) -> Date? {
    let trimmedISOString = ISOString.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
    let formatter = ISO8601DateFormatter()
    let date = formatter.date(from: trimmedISOString)
    
    return date
}

class AYRAttendee {
    let user: AYRUser
    let status: AttendeeStatus
    
    init(user: AYRUser, status: AttendeeStatus = .pending) {
        self.user = user
        self.status = status
    }
    
    init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let jsonUser = json["user"],// as? Any,
              let jsonStatus = json["status"] as? String
        else {
            return nil
        }
        
        guard let user = AYRUser(fromJSON: jsonUser),
              let status = AttendeeStatus(rawValue: jsonStatus)
        else {
            return nil
        }
        
        self.user = user
        self.status = status
    }
}

class AYREvent {
    let name: String
    let type: EventType?
    let description: String
    let location: String
    let meetupLocation: EventMeetupLocation?
    let createdBy: AYRUser
    let createdAt: Date
    let notificationTime: Date
    let readyTime: Date
    let attendees: [String: AYRAttendee]
    
    init(name: String, type: EventType?, description: String, location: String, meetupLocation: EventMeetupLocation?, createdBy: AYRUser, createdAt: Date, notificationTime: Date, readyTime: Date, attendees: [String: AYRAttendee]) {
        self.name = name
        self.type = type
        self.description = description
        self.location = location
        self.meetupLocation = meetupLocation
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.notificationTime = notificationTime
        self.readyTime = readyTime
        self.attendees = attendees
    }
    
    init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let jsonName = json["name"] as? String,
              let jsonType = json["type"] as? String,
              let jsonDescription = json["description"] as? String,
              let jsonLocation = json["location"] as? String,
              let jsonMeetupLocation = json["meetupLocation"] as? String,
              let jsonCreatedBy = json["createdBy"],// as? Any,
              let jsonCreatedAt = json["createdAt"] as? String,
              let jsonNotificationTime = json["notificationTime"] as? String,
              let jsonReadyTime = json["readyTime"] as? String,
              let jsonAttendees = json["attendees"] as? [Any]
        else {
            return nil
        }

        let type = EventType(rawValue: jsonType)
        let meetupLocation = EventMeetupLocation(rawValue: jsonMeetupLocation)
        
        guard let createdBy = AYRUser(fromJSON: jsonCreatedBy)
        else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        guard let createdAt = parseISODate(jsonCreatedAt),
              let notificationTime = parseISODate(jsonNotificationTime),
              let readyTime = parseISODate(jsonReadyTime)
        else {
            return nil
        }

        var attendees = [String: AYRAttendee]()
        for jsonAttendee in jsonAttendees {
            if let attendee = AYRAttendee(fromJSON: jsonAttendee) {
                attendees[attendee.user.name] = attendee
            } else {
                return nil
            }
        }

        self.name = jsonName
        self.type = type
        self.description = jsonDescription
        self.location = jsonLocation
        self.meetupLocation = meetupLocation
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.notificationTime = notificationTime
        self.readyTime = readyTime
        self.attendees = attendees
    }
}
