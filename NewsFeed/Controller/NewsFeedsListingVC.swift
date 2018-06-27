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
    var gridTopHeadlines: UICollectionView! {
        didSet {
            gridTopHeadlines.dataSource = self
            gridTopHeadlines.delegate = self
        }
    }
    @IBOutlet var tblNewsFeed: UITableView!
    var topHeadlines: [NewsFeed] = [] {
        didSet {
            gridTopHeadlines.reloadData()
        }
    }
    var newsFeeds: [NewsFeed] = [] {
        didSet {
            tblNewsFeed.reloadData()
        }
    }
    var selectedSource = "the-wall-street-journal"
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "News Feeds"
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search

        // Do any additional setup after loading the view.
        barBtnRevealToggle.target = self.revealViewController()
        barBtnRevealToggle.action = Selector("revealToggle:")
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        callTopHeadlines(page: 1)
        callEverything(page: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sourceSelected(_:)), name: NSNotification.Name("SourceSelected"), object: nil)
    }
    
    @objc
    func sourceSelected(_ sender: Notification) {
        selectedSource = sender.userInfo!["source"] as! String
        callEverything(page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func callTopHeadlines(page: Int) {
        WebService.shared.callAPI(.get, api: .topHeadlines, parameters: ["page": String(page), "country": "us"]) { (response) in
            unowned let this = self
            print(response)
            this.topHeadlines = NewsFeed.populateArray(response["articles"] as! [[String : Any]])
        }
    }
    
    func callEverything(page: Int, searchQuery: String = "" ) {
        WebService.shared.callAPI(.get, api: .everything, parameters: ["page": String(page), "sources": selectedSource, "q": searchQuery]) { (response) in
            unowned let this = self
            if page == 1  {
                this.newsFeeds = NewsFeed.populateArray(response["articles"] as! [[String : Any]])
            } else {
                this.newsFeeds.append(contentsOf: NewsFeed.populateArray(response["articles"] as! [[String : Any]]))
            }
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
        if let urlToImage = topHeadlines[indexPath.row].urlToImage, let url = URL(string: urlToImage) {
//            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: urlToImage)!)
            cell.imgHeadline.kf.setImage(with: url)
        } else {
//            (cell.viewWithTag(1) as! UIImageView).image = nil
            cell.imgHeadline.image = nil
        }
        
        cell.lblHeadline.text = topHeadlines[indexPath.row].title
        cell.lblHeadline.backgroundColor = .clear
        
        guard indexPath.row + 1 == topHeadlines.count else {
            return cell
        }
        
        callTopHeadlines(page: topHeadlines.count/20+1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "NewsFeedDetailVC") as! NewsFeedDetailVC
        destination.newsFeed = topHeadlines[indexPath.row]
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height*16/10, height: collectionView.bounds.height)
    }
}

extension NewsFeedsListingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeeds.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headlinesContainer", for: indexPath) as! HeadlinesContainerTVC
            self.gridTopHeadlines = cell.gridTopHeadlines
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeed", for: indexPath) as! NewsFeedTVC
//            cell.textLabel?.text = topHeadlines[indexPath.row - 1]["title"] as? String
            if let urlToImage = newsFeeds[indexPath.row - 1].urlToImage, let url = URL(string: urlToImage) {
                //            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: urlToImage)!)
                cell.imgNewsFeed.kf.setImage(with: url)
            } else {
                //            (cell.viewWithTag(1) as! UIImageView).image = nil
                cell.imgNewsFeed.image = nil
            }
            cell.lblNewsFeedTitle.text = newsFeeds[indexPath.row - 1].title
            
            guard newsFeeds.count == indexPath.row else {
                return cell
            }
            
            callEverything(page: newsFeeds.count/20 + 1)
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "NewsFeedDetailVC") as! NewsFeedDetailVC
        destination.newsFeed = newsFeeds[indexPath.row]
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.bounds.height / 5
        } else {
            return 66
        }
    }
}

extension NewsFeedsListingVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            unowned let this = self
            this.callEverything(page: 1, searchQuery: searchController.searchBar.text!)
        })
    }
}
