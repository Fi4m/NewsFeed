//
//  NewsFeed.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 28/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import Foundation

struct NewsFeed {
    let urlToImage: String?
    let title: String
    let description: String?
    let url: String?
    
    init(_ dict: [String : Any]) {
        urlToImage = dict["urlToImage"] as? String
        title = dict["title"] as! String
        description = dict["description"] as? String
        url = dict["url"] as? String
    }
    
    static func populateArray(_ array: [[String:Any]]) -> [NewsFeed] {
        var newsFeeds: [NewsFeed] = []
        for eachDict in array {
            newsFeeds.append(NewsFeed(eachDict))
        }
        return newsFeeds
    }
}
