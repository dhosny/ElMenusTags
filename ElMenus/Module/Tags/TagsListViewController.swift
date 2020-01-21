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
       
        initView()
        
        initTagsVM()
    }
    
    func initView() {
        self.navigationItem.title = NSLocalizedString("Welcome To ElMenus", comment: "")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.estimatedRowHeight = 150
        itemsTableView.rowHeight = UITableView.automaticDimension
        

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
                //self?.itemsViewModel = self?.tagsViewModel.createItemViewModel()
                //self?.itemsViewModel.initFetch()
            }
        }
        
//        tagsViewModel.reloadItemsViewClosure = { [weak self] () in
//            DispatchQueue.main.async {
//                //self?.initItemsVM()
//                self?.itemsViewModel.initFetch()
//            }
//        }
        itemsViewModel  = tagsViewModel.createItemViewModel()
        initItemsVM()
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
                        self.itemsTableView.alpha = 0.0
                    })
                case .loading:
                    SVProgressHUD.show()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.itemsTableView.alpha = 0.0
                    })
                case .loaded:
                    SVProgressHUD.dismiss()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.itemsTableView.alpha = 1.0
                    })
                }
            }
        }
        
        itemsViewModel.reloadItemsViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.itemsTableView.reloadData()
            }
        }
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tagsViewModel.userPressed(at: indexPath)
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        itemsViewModel.userPressed(at: indexPath)
        return indexPath
    }
    
    
}

extension TagsListViewController: UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == itemsTableView{
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if translation.y > 0 {
                // swipes from top to bottom of screen -> down
                print(" // move down   111111111 2324234 34343")
                UIView.animate(withDuration: 0.5, animations: {
                    //self.upperViewHeight.constant = 120
                    self.view.layoutIfNeeded()
                    
                })
                
            }
            else {
                // swipes from bottom to top of screen -> up
                print(" // move up  ........ ..... ..... .. .")
                UIView.animate(withDuration: 0.5, animations: {
                    //self.upperViewHeight.constant = 0
                    self.view.layoutIfNeeded()
                    
                })
                
            }
            
        }
    }
}
extension TagsListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemDetailsViewController,
            let item = itemsViewModel.selectedItem {
            vc.itemData = item
        }
    }
}
