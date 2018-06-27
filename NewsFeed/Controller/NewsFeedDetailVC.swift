//
//  NewsFeedDetailVC.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 28/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import UIKit

class NewsFeedDetailVC: UIViewController {

    @IBOutlet weak var imgNewsFeed: UIImageView!
    @IBOutlet weak var lblNewsFeedTitle: UILabel!
    @IBOutlet weak var lblNewsFeedDescription: UILabel!
    
    var newsFeed: NewsFeed!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let urlToImage = newsFeed.urlToImage, let url = URL(string: urlToImage) {
            //            (cell.viewWithTag(1) as! UIImageView).kf.setImage(with: URL(string: urlToImage)!)
            imgNewsFeed.kf.setImage(with: url)
        } else {
            //            (cell.viewWithTag(1) as! UIImageView).image = nil
            imgNewsFeed.image = nil
        }
        
        lblNewsFeedTitle.text = newsFeed.title
        lblNewsFeedDescription.text = newsFeed.description
        
        navigationItem.title = "News Feed Detail"
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

    @IBAction func btnVisitAction(_ sender: UIButton) {
        guard let urlString = newsFeed.url, let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
