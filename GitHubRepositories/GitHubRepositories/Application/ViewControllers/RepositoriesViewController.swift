//
//  ViewController.swift
//  GitHubRepositories
//
//  Created by Ravi on 17/06/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

import CoreData

class RepositoriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageIndex: UInt = 0
    
    var query = "tetris"
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: Repository.entityName)
        
        let descriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        request.sortDescriptors = descriptors
        
        // init with main context
        let resultsController = NSFetchedResultsController.init(fetchRequest: request, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return resultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureInitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func configureInitialSetup() {
        self.title = "Repositories"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        // Register cell
        self.collectionView!.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellWithReuseIdentifier: RepositoryCell.cellIdentifier)

        // Assign Delegate and Datasource
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        
        // Fetch data from Server
        self.fetchData(pageIndex, query: query)
    }
    
    fileprivate func fetchData(_ pageIndex: UInt?, query: String?) {
        ServiceManager.fetchServiceData(pageIndex, query: query) { (data, error) in
            if let errorMessage = error?.localizedDescription {
                UIAlertController.showAlertWith(errorMessage, sender: self)
            } else {
                // Fetch data from coredata
                do {
                    try self.fetchedResultsController.performFetch()
                } catch let error {
                    fatalError(" Error which performFetch \(error.localizedDescription)")
                }
                
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            }
        }
    }
}

extension RepositoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let repository = self.fetchedResultsController.object(at: indexPath) as! Repository
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCell.cellIdentifier, for: indexPath) as! RepositoryCell
        cell.configure(repository)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 20
        let height:CGFloat =  135.0
        
        return  CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
