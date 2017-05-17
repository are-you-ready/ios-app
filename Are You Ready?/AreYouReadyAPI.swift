//
//  AreYouReadyAPI.swift
//  Are You Ready?
//
//  Created by Markus Tran on 5/17/17.
//  Copyright © 2017 Markus Tran. All rights reserved.
//

import UIKit

// http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
#if (arch(i386) || arch(x86_64)) && os(iOS)
    let BASE_API_URL = URL(string: "http://localhost:3000")!
#else
    let BASE_API_URL = URL(string: "http://ayr.pf-n.co")!
#endif

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
