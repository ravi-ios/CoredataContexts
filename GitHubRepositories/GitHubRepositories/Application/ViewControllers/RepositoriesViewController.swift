//
//  ViewController.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageIndex: UInt = 0
    
    var query = "tetris"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialSetup()
        
        self.fetchData(pageIndex, query: query)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func configureInitialSetup() {
        self.title = "Repositories"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    fileprivate func fetchData(_ pageIndex: UInt?, query: String?) {
        ServiceManager.fetchServiceData(pageIndex, query: query) { (data, error) in
            if let errorMessage = error?.localizedDescription {
                UIAlertController.showAlertWith(errorMessage, sender: self)
            }
        }
    }
}

