//
//  ItemDetailsViewController.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/21/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class ItemDetailsViewController: UIViewController {
    
    var itemData: Item?

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var descrptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = itemData?.name
        descrptionLbl.text = itemData?.descriptionField
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
                .transition(.fade(1)),
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
    }
    

}
