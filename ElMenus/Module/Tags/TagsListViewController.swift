//
//  TagsListViewController.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/20/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import UIKit
import SVProgressHUD

class TagsListViewController: UIViewController {

    var tagsViewModel: TagsListViewModel!
    
    var itemsViewModel: ItemsListViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagsViewModel = TagsListViewModel()
        itemsViewModel = ItemsListViewModel()
        
        initView()
        initTagsVM()
        initItemsVM()
        
    }
    
    func initView() {
        self.navigationItem.title = NSLocalizedString("Welcome To ElMenus", comment: "")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self

    }
    
    func initTagsVM() {
        
        // binding
        tagsViewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.tagsViewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        tagsViewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.tagsViewModel.state {
                case .empty, .error:
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 0.0
                    })
                case .loading:
                    SVProgressHUD.show()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 0.0
                    })
                case .loaded:
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 1.0
                    })
                }
            }
        }
        
        tagsViewModel.reloadTagsViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        tagsViewModel.initFetch()
        
    }
    
    func initItemsVM() {
        
        // binding
        itemsViewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.itemsViewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        itemsViewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.itemsViewModel.state {
                case .empty, .error:
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 0.0
                    })
                case .loading:
                    SVProgressHUD.show()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 0.0
                    })
                case .loaded:
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 1.0
                    })
                }
            }
        }
        
        itemsViewModel.reloadItemsViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.itemsTableView.reloadData()
            }
        }
        
        itemsViewModel.initFetch(withTagName: "1 - Egyptian")
        
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        if let presentedVC = presentedViewController {
            presentedVC.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension TagsListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsViewModel.numberOfTagsCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.IDENTIFIER, for: indexPath) as? TagCollectionViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = tagsViewModel.getTagCellViewModel(at: indexPath )
        cell.tagCellVM = cellVM
        
        return cell
        
    }
    
}


extension TagsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.IDENTIFIER, for: indexPath) as? ItemTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = itemsViewModel.getItemCellViewModel(at: indexPath )
        cell.cellVM = cellVM
        
        return cell
    }
    
    
}
