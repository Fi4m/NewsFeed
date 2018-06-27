//
//  topHeadlinesListing.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 26/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import UIKit
import Kingfisher
import SWRevealViewController

class NewsFeedsListingVC: UIViewController {
    
    @IBOutlet var barBtnRevealToggle: UIBarButtonItem!
    @IBOutlet var gridTopHeadlines: UICollectionView!
    @IBOutlet var tblNewsFeed: UITableView!
    var topHeadlines: [[String:Any]] = [] {
        didSet {
            if oldValue.count != topHeadlines.count {
                gridTopHeadlines.reloadData()
            }
        }
    }
    var newsFeeds: [[String:Any]] = [] {
        didSet {
            if oldValue.count != newsFeeds.count {
                tblNewsFeed.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "News Feed"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search

        // Do any additional setup after loading the view.
        barBtnRevealToggle.target = self.revealViewController()
        barBtnRevealToggle.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        callTopHeadlines(page: 0)
//        callEverything(page: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sourceSelected(_:)), name: NSNotification.Name("SourceSelected"), object: nil)
    }
    
    @objc
    func sourceSelected(_ sender: Notification) {
        let source = sender.userInfo!["source"] as! String
        callEverything(page: 0, source: source)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func callTopHeadlines(page: Int) {
        WebService.shared.callAPI(.get, api: .topHeadlines, parameters: ["page": String(page), "country": "us"]) { (response) in
            unowned let this = self
            this.topHeadlines.append(contentsOf: response["articles"] as! [[String : Any]])
        }
    }
    
    func callEverything(page: Int, source: String = "the-wall-street-journal" ) {
        WebService.shared.callAPI(.get, api: .everything, parameters: ["page": String(page), "sources": source]) { (response) in
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

extension NewsFeedsListingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topHeadlines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headlines", for: indexPath) as! TopHeadlinesCVC
        if let urlToImage = topHeadlines[indexPath.row]["urlToImage"] as? String {
//            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: urlToImage)!)
            cell.imgHeadline.kf.setImage(with: URL(string: urlToImage)!)
        } else {
//            (cell.viewWithTag(1) as! UIImageView).image = nil
            cell.imgHeadline.image = nil
        }
        
        cell.lblHeadline.text = topHeadlines[indexPath.row]["title"] as? String
        cell.lblHeadline.backgroundColor = .clear
        
        guard indexPath.row + 1 == topHeadlines.count else {
            return cell
        }
        
        callTopHeadlines(page: topHeadlines.count/20+1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height*16/10, height: collectionView.bounds.height)
    }
}

extension NewsFeedsListingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeed", for: indexPath)
        cell.textLabel?.text = newsFeeds[indexPath.row]["title"] as? String
        return cell
    }
}

extension NewsFeedsListingVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
