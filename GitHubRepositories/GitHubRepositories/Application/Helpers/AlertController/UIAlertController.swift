//
//  UIAlertController.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func showAlertWith(_ message: String?, sender: AnyObject?) {
        let error = message ?? "Error while fetching data, please try later"
        
        let alertController = UIAlertController(title: "Error" , message: error, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction.init(title:"Ok" , style: .default, handler: { (action) in
        }))
        
        DispatchQueue.main.async {
            sender?.present(alertController, animated: true, completion: nil)
        }
    }
}
