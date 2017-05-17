//
//  AreYouReadyAPI.swift
//  Are You Ready?
//
//  Created by Markus Tran on 5/17/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

let BASE_API_URL = URL(string: "http://ayr.pf-n.co")!
let session = URLSession(configuration: URLSessionConfiguration.default)

class AreYouReadyAPI {
    static func getProfile(name: String, completionHandler: @escaping ([String: Any]?, Error?) -> Void) {
        let endpoint = URL(string: "/profile/\(name)", relativeTo: BASE_API_URL)!
        let urlRequest = URLRequest(url: endpoint)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            do {
                if let data = data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    completionHandler(json, nil)
                    return
                } else {
                    // When is this block reached?
                }
            } catch {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}
