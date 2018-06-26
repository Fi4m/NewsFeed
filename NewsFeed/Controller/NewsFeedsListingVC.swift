//
//  NewsFeedsListing.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 26/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import UIKit
import Kingfisher

class NewsFeedsListingVC: UITableViewController {
    
    var newsFeeds: [[String:Any]] = [] {
        didSet {
            if oldValue.count != newsFeeds.count {
                tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callTopHeadlines(page: 0)
    }
    
    func callTopHeadlines(page: Int) {
        WebService.shared.callAPI(.get, api: .topHeadlines, parameters: ["page": String(page)]) { (response) in
            unowned let this = self
            this.newsFeeds.append(contentsOf: response["articles"] as! [[String : Any]])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsFeedsListingVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeed", for: indexPath)
        if let urlToImage = newsFeeds[indexPath.row]["urlToImage"] as? String {
            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: urlToImage)!)
        } else {
            (cell.viewWithTag(1) as! UIImageView).image = nil
        }
        
        cell.textLabel?.text = newsFeeds[indexPath.row]["title"] as? String
        cell.textLabel?.backgroundColor = .clear
        
        guard indexPath.row + 1 == newsFeeds.count else {
            return cell
        }
        
        callTopHeadlines(page: newsFeeds.count/20+1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
