//
//  AYRUser.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/5/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import Foundation

class AYRUser {
    let name: String
    let _active: Bool // This property is NOT used
    
    init(name: String, _active: Bool = true) {
        self.name = name
        self._active = _active
    }
    
    init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let jsonName = json["name"] as? String,
              let jsonActive = json["active"] as? Bool
        else {
            return nil
        }
        
        self.name = jsonName
        self._active = jsonActive
    }
}
