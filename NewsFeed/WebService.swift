//
//  WebService.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 26/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import Foundation

let NEWSAPI_API_KEY = "1f013561bdd14bddaa9e60ef255a1b04"

enum API: String {
    case topHeadlines = "top-headlines"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class WebService {
    static let shared = WebService()
    
    let baseURL = "https://newsapi.org/v2/"
    let session = URLSession(configuration: .default)
    
    func callAPI(_ method: HTTPMethod,api: API, parameters: [String:Any]!, completionHandler: @escaping (([String:Any]) -> Void)) {
        var queryString  = ""
        for eachKey in parameters.keys {
            queryString.append("&\(eachKey)=\(parameters[eachKey] as! String)")
        }
        let dataTask = session.dataTask(with: URL(string: "\(baseURL)\(api.rawValue)?apiKey=\(NEWSAPI_API_KEY)&country=in\(queryString)")!) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            let dict = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
            print(dict)
            DispatchQueue.main.async {
                completionHandler(dict)
            }
        }
        dataTask.resume()
    }
}
