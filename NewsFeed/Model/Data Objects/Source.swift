//
//  Source.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 28/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import Foundation

struct Source: Decodable {
    let id: String
    let name: String
    
    init(_ dict: [String : Any]) {
        id = dict["id"] as! String
        name = dict["name"] as! String
    }
    
    static func populateArray(_ array: [[String:Any]]) -> [Source] {
        var sources: [Source] = []
        for eachDict in array {
            sources.append(Source(eachDict))
        }
        return sources
    }
}
