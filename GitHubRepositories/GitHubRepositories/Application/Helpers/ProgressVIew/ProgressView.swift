//
//  ProgressView.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    @IBOutlet weak var progressIndicator: UIImageView!
    
    lazy var spalshImages: [UIImage] = {
        var images: [UIImage] = []
        for index in 0...208 {
            let image = UIImage(named: "tmp-\(index)")
            images.append(image!)
        }
        return images
    }()
    
    class var shared: ProgressView {
        struct Indicator {
            static let instance : ProgressView = ProgressView.instance() as! ProgressView
        }
        return Indicator.instance
    }
    
    fileprivate func startAnimation() {
        progressIndicator.animationImages = ProgressView.shared.spalshImages
        progressIndicator.animationDuration = 8.0
        progressIndicator.animationRepeatCount = 0
        progressIndicator.startAnimating()
    }
    
    fileprivate func stopAnimation() {
        progressIndicator.stopAnimating()
    }
    
    func show() {
        //        DispatchQueue.main.async {
        self.startAnimation()
        var window = UIApplication.shared.keyWindow
        
        if window == nil {
            window = UIApplication.shared.windows[0]
        }
        
        window?.addSubview(ProgressView.shared)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintX = NSLayoutConstraint.init(item: ProgressView.shared, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let constraintY = NSLayoutConstraint.init(item: ProgressView.shared, attribute: .centerY, relatedBy: .equal, toItem: window, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        window?.addConstraints([constraintX, constraintY])
        self.layoutIfNeeded()
        //        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            ProgressView.shared.stopAnimation()
            ProgressView.shared.removeFromSuperview()
        }
    }
}

extension UIView {
    class func instance() -> UIView {
        let classString : String = NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
        return Bundle.main.loadNibNamed(classString, owner: self, options: nil)![0] as! UIView
    }
    
    class func nib() -> UINib {
        let classString : String = NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
        return UINib.init(nibName: classString, bundle: nil)
    }
}
