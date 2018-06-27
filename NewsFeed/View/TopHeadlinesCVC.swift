//
//  TopHeadlinesCVC.swift
//  NewsFeed
//
//  Created by Vedant Mahant on 27/06/18.
//  Copyright © 2018 Vedant Mahant. All rights reserved.
//

import UIKit

class TopHeadlinesCVC: UICollectionViewCell {
    @IBOutlet weak var imgHeadline: UIImageView!
    @IBOutlet weak var lblHeadline: UILabel!
    
    var gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 2)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        imgHeadline.layer.addSublayer(gradientLayer)
    }
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = imgHeadline.bounds
    }
}
