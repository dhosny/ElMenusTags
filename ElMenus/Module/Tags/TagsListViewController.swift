//
//  TagsListViewController.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/20/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import UIKit
import SVProgressHUD
import NotificationBannerSwift

class TagsListViewController: UIViewController {

    var tagsViewModel: TagsListViewModel!
    
    var itemsViewModel: ItemsListViewModel!
    
    let MAX_TAGS_HIGHT = CGFloat(100)
    
    var loadingView: LoadingReusableView?
    @IBOutlet weak var collectionViewHieght: NSLayoutConstraint!
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
        //Register Loading Reuseable View
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
        
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
                    //SVProgressHUD.dismiss()
                    self.loadingView?.activityIndicator.stopAnimating()
                    self.loadingView?.activityIndicator.isHidden = true
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 0.0
                    })
                case .loading:
                    //SVProgressHUD.show()
                    self.loadingView?.activityIndicator.startAnimating()
                    self.loadingView?.activityIndicator.isHidden = false
//                    UIView.animate(withDuration: 0.2, animations: {
//                        //self.collectionView.alpha = 0.5
//                        self.loadingView?.activityIndicator.startAnimating()
//                    })
                case .loaded:
                    //SVProgressHUD.dismiss()
                    self.loadingView?.activityIndicator.stopAnimating()
                    self.loadingView?.activityIndicator.isHidden = true
                    UIView.animate(withDuration: 0.2, animations: {
                        self.collectionView.alpha = 1.0
                        //self.loadingView?.activityIndicator.stopAnimating()
                    })
                }
            }
        }
        
        tagsViewModel.reloadTagsViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        tagsViewModel.updateDataModeStatus = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.tagsViewModel.dataMode?.rawValue {
                    let type = (self?.tagsViewModel.dataMode == .offLine)
                    self?.showBanner(message, error: type )
                }
            }
        }
        
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
                    self.showBanner("No Items Loaded", error: true)
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
        
        itemsViewModel.updateDataModeStatus = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.itemsViewModel.dataMode?.rawValue {
                    let type = (self?.itemsViewModel.dataMode == .offLine)
                    self?.showBanner(message, error: type )
                }
            }
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        //self.present(alert, animated: true, completion: nil)
        if let presentedVC = presentedViewController {
            presentedVC.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showBanner(_ message: String, error: Bool){
        let banner = NotificationBanner(title: "Elmenus", subtitle: message, style: (error ? .danger :.success))
        banner.show()
    }

}

extension TagsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.tagsViewModel.numberOfTagsCells - 2 {
            // Load next batch of tags
            self.tagsViewModel.loadNextPage()
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    
       return CGSize(width: 40, height: collectionView.bounds.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.startAnimating()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
//        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.stopAnimating()
//        }
//    }
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
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if tableView == itemsTableView {
//            if indexPath.row == 0 {
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.collectionViewHieght.constant = self.MAX_TAGS_HIGHT
//                    self.view.layoutIfNeeded()
//
//                })
//            }
//        }
//    }
    
    
}

extension TagsListViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == itemsTableView && tagsViewModel.state == .loaded && itemsViewModel.state == .loaded{
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if translation.y > 0 {
                // swipes from top to bottom of screen -> down
                //print(" // move down   111111111 2324234 34343")
                 if self.collectionViewHieght.constant == 0 {
                    if ((itemsTableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)))!) {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.collectionViewHieght.constant = self.MAX_TAGS_HIGHT
                            self.view.layoutIfNeeded()
                            
                        })
                    }
                }
                
            } else {
                // swipes from bottom to top of screen -> up
                //print(" // move up  ........ ..... ..... .. .")
                if self.collectionViewHieght.constant == MAX_TAGS_HIGHT {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.collectionViewHieght.constant = 0
                        self.view.layoutIfNeeded()
                        
                    })
                }
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
