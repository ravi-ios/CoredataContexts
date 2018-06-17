//
//  RepositoryCell.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    
    static let cellIdentifier = "Cell"

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var estimatedDownloadTimeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var repoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyCardEffect()
    }
    
    func configure(_ data: Repository?) {
        
        if data?.hasWiki ?? false {
            self.backView.backgroundColor = UIColor(red:0.00, green:0.44, blue:0.70, alpha:0.30)
        } else {
            self.backView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.1)
        }
        
        let name = data?.name ?? ""
        let ownerName = data?.owner?.name ?? ""
        
        repoTitleLabel.text = "Repository: \(name)"
        ownerLabel.text = "Owner: \(ownerName)"
        
        if let size = data?.size {
            sizeLabel.text = ("Size: \(size) KB")
        }
        
        if let time = data?.estimatedDownloadTime {
            if time < 120 {
                estimatedDownloadTimeLabel.text = ("Estimated download time: \(time) sec")
                
            } else if time < 3600 {
                estimatedDownloadTimeLabel.text = ("Estimated download time: \(String(format: "%.1f", Float(time) / 60.0)) min")
                
            } else {
                estimatedDownloadTimeLabel.text = ("Estimated download time: \(String(format: "%.1f", Float(time) / 3600.0)) hr")
            }
        }
    }
    
    fileprivate func applyCardEffect() {
        self.cardView.alpha = 1.0
        self.cardView.layer.masksToBounds = false
        self.cardView.layer.cornerRadius = 10.0
        self.cardView.layer.shadowOffset = CGSize.zero
        self.cardView.layer.shadowRadius = 2.0
        self.cardView.layer.shadowColor = UIColor.red.cgColor
        self.cardView.layer.shadowOpacity = 1.0
        
        self.backView.layer.cornerRadius = 10.0
    }

}
