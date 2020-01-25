//
//  ItemDetailsViewController.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/21/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//
//
import UIKit
import Kingfisher
import Hero

class ItemDetailsViewController: UIViewController {
    
    var itemData: Item?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var toolBarImg: UIImageView!
    @IBOutlet weak var descrptionTextView: UITextView!
    
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toolBarHeightConstrain: NSLayoutConstraint!
    
    var lastContentOffset: CGFloat = 0.0
    let maxImageHeight: CGFloat = 200
    let maxToolBarHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = itemData?.name
        
        self.toolBarHeightConstrain.constant = 0.0
        descrptionTextView.text = itemData?.descriptionField
        setImg(url: itemData?.photoUrl)
        
        //transtion animation
        self.hero.isEnabled = true
        imgView.heroID = "itemCellHeroId-\(itemData?.id ?? 0)"
        //descrptionLbl.hero.modifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]
    
    }
    
    private func setImg(url: String?) {
        let url = URL(string: url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let processor = DownsamplingImageProcessor(size: imgView.frame.size)
            |> RoundCornerImageProcessor(cornerRadius: 30)
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "imgHolder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                //.transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
        toolBarImg.kf.setImage(
            with: url,
            placeholder: UIImage(named: "imgHolder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                //.transition(.fade(1)),
                .cacheOriginalImage
            ])
    }

}

// MARK: - UIScrollViewDelegate
extension ItemDetailsViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //Scrolled to bottom
            UIView.animate(withDuration: 0.3) {
                self.imgHeightConstraint.constant = 0.0
                self.toolBarHeightConstrain.constant = self.maxToolBarHeight
                self.view.layoutIfNeeded()
            }
        } else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= 0) && (self.imgHeightConstraint.constant != self.maxImageHeight)  {
            //Scrolling up, scrolled to top
            print(scrollView.contentOffset.y)
            UIView.animate(withDuration: 0.3) {
                self.imgHeightConstraint.constant = self.maxImageHeight
                self.toolBarHeightConstrain.constant = 0.0
                self.view.layoutIfNeeded()
            }
        } else if (scrollView.contentOffset.y > self.lastContentOffset) && self.imgHeightConstraint.constant != 0.0 {
            //Scrolling down
            UIView.animate(withDuration: 0.3) {
                self.imgHeightConstraint.constant = 0.0
                self.toolBarHeightConstrain.constant = self.maxToolBarHeight
                self.view.layoutIfNeeded()
            }
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
}


