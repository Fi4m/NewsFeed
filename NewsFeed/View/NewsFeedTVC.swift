//
//  NewsFeedTVC.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 28/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import UIKit

class NewsFeedTVC: UITableViewCell {

    @IBOutlet weak var imgNewsFeed: UIImageView!
    @IBOutlet weak var lblNewsFeedTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
