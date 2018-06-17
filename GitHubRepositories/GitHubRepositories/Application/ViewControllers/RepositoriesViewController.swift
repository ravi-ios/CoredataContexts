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
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageIndex: UInt = 0
    
    var query = "tetris"
    
    var blockOperation = [BlockOperation]()
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: Repository.entityName)
        
        let descriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
        request.sortDescriptors = descriptors
        
        // init with main context
        let resultsController = NSFetchedResultsController.init(fetchRequest: request, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        resultsController.delegate = self
        
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
        
        self.searchField.layer.cornerRadius = 5.0
        self.searchField.layer.borderColor = UIColor.darkGray.cgColor
        self.searchField.layer.borderWidth = 2.0
        
        searchField.text = query
        
        // Register cell
        self.collectionView!.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellWithReuseIdentifier: RepositoryCell.cellIdentifier)
        
        // Assign Delegate and Datasource
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Fetch data from Server
        self.fetchData(pageIndex, query: searchField.text)
        
        // Fetch data from coredata
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error {
            fatalError(" Error which performFetch \(error.localizedDescription)")
        }
    }
    
    fileprivate func fetchData(_ pageIndex: UInt?, query: String?) {
        ServiceManager.fetchServiceData(pageIndex, query: query) { (data, error) in
            if let errorMessage = error?.localizedDescription {
                UIAlertController.showAlertWith(errorMessage, sender: self)
            }
        }
    }
    
    @IBAction func searchRepositories(_ sender: Any) {
        if searchField.text?.count == 0 {
          searchField.text = query
        }
        
        if query == searchField.text {
            pageIndex = pageIndex + 1
        } else {
            pageIndex = 0
        }
        self.fetchData(pageIndex, query: searchField.text)
    }
    deinit {
        for operation in self.blockOperation {
            operation.cancel()
        }
        self.blockOperation.removeAll()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let count = self.fetchedResultsController.sections?[indexPath.section].numberOfObjects ?? 0
        
        if indexPath.row + 2 == count {
            pageIndex = pageIndex + 1
            self.fetchData(pageIndex, query: searchField.text)
        }
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

extension RepositoriesViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard type == .insert else { return }
        guard let indexPath = newIndexPath else { return }
        
        blockOperation.append(BlockOperation.init(block: {
            self.collectionView.insertItems(at: [indexPath])
        }))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({
            for operation in self.blockOperation {
                operation.start()
            }
        }) { (status) in
            self.blockOperation.removeAll()
        }
    }
}

extension RepositoriesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
