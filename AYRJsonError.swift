//
//  AYRJsonError.swift
//  Are You Ready?
//
//  Created by Markus Tran on 6/5/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import Foundation

class AYRJsonError {
    let code: Int
    let description: String
    
    init(code: Int, description: String) {
        self.code = code
        self.description = description
    }
    
    init?(fromJSON json: Any?) {
        guard let json = json as? [String: Any],
              let jsonErrorCode = json["errorCode"] as? Int,
              let jsonErrorDescription = json["errorDescription"] as? String
        else {
            return nil
        }
        
        self.code = jsonErrorCode
        self.description = jsonErrorDescription
    }
}
