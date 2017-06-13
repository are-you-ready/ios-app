//
//  AYRUser.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/5/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

class AYRPartialUser {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let name = json["name"] as? String
        else {
            return nil
        }
        
        self.name = name
    }
}

class AYRUser: AYRPartialUser {
    let groups: [String: AYRGroup]
    
    init(name: String, groups: [String: AYRGroup]) {
        self.groups = groups
        super.init(name: name)
    }
    
    override init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let name = json["name"] as? String,
              let groups = json["groups"] as? [Any]
        else {
            return nil
        }
        
        var parsedGroups = [String: AYRGroup]()
        for group in groups {
            if let parsedGroup = AYRGroup(fromJSON: group) {
                parsedGroups[parsedGroup.name] = parsedGroup
            } else {
                return nil
            }
        }
        
        self.groups = parsedGroups
        super.init(name: name)
    }
}
