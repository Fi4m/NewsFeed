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
    case everything = "everything"
    case sources = "sources"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}



class WebService {
    static let shared = WebService()
    
    let baseURL = "https://newsapi.org/v2/"
    let session = URLSession(configuration: .default)
    let urlCache = NSCache<NSURL, NSData>()
    
    func callAPI(_ method: HTTPMethod,api: API, parameters: [String:Any]!, completionHandler: @escaping (([String:Any]) -> Void)) {
        var queryString  = ""
        for eachKey in parameters.keys {
            queryString.append("&\(eachKey)=\(parameters[eachKey] as! String)")
        }
        
        let url = URL(string: "\(baseURL)\(api.rawValue)?apiKey=\(NEWSAPI_API_KEY)\(queryString)")!
        print(url)
        
        if let cachedData = urlCache.object(forKey: url as NSURL) {
            let cachedDict = self.parseJSON(data: cachedData as Data)
            completionHandler(cachedDict)
        } else {
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                unowned let this = self
                
                guard error == nil else {
                    return
                }
                this.urlCache.setObject(data! as NSData, forKey: url as NSURL)
                let dict = this.parseJSON(data: data!)
                print(dict)
                
                DispatchQueue.main.async {
                    completionHandler(dict)
                }
            }
            dataTask.resume()
        }
    }
    
    func parseJSON(data: Data) -> [String:Any] {
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
    }
}
