//
//  AYRGroup.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/5/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

class AYRGroup {
    let name: String
    let users: [String: AYRPartialUser]
//    let events: [String: AYREvent]
    
    init(name: String, users: [String: AYRPartialUser]) {
        self.name = name
        self.users = users
    }
    
    init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let name = json["name"] as? String,
              let users = json["users"] as? [Any]
        else {
            return nil
        }
        
        var parsedUsers = [String: AYRPartialUser]()
        for user in users {
            if let parsedUser = AYRPartialUser(fromJSON: user) {
                parsedUsers[parsedUser.name] = parsedUser
            } else {
                return nil
            }
        }
        
        self.name = name
        self.users = parsedUsers
    }
}
