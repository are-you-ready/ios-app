//
//  AYRGroup.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/5/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import Foundation

class AYRGroup {
    let name: String
    let users: [String: AYRUser]
    let events: [String: AYREvent]
    
    init(name: String, users: [String: AYRUser], events: [String: AYREvent]) {
        self.name = name
        self.users = users
        self.events = events
    }
    
    init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let jsonName = json["name"] as? String,
              let jsonUsers = json["users"] as? [Any],
              let jsonEvents = json["events"] as? [Any]
        else {
            return nil
        }

        var users = [String: AYRUser]()
        for jsonUser in jsonUsers {
            if let user = AYRUser(fromJSON: jsonUser) {
                users[user.name] = user
            } else {
                return nil
            }
        }

        var events = [String: AYREvent]()
        for jsonEvent in jsonEvents {
            if let event = AYREvent(fromJSON: jsonEvent) {
                events[event.name] = event
            } else {
                return nil
            }
        }

        self.name = jsonName
        self.users = users
        self.events = events
    }
}
