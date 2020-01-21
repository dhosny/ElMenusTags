//
//  TagCollectionViewCell.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/20/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import UIKit
import Kingfisher

class TagCollectionViewCell: UICollectionViewCell {
    
    static let IDENTIFIER = "TagCellId"
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tagImageView: UIImageView!
    
    var tagCellVM : TagsListCellViewModel? {
        didSet {
            nameLbl.text = tagCellVM?.titleText
            self.setImg(url: tagCellVM?.imageUrl)
        }
    }
    
    private func setImg(url: String?) {
        let url = URL(string: url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let processor = DownsamplingImageProcessor(size: tagImageView.frame.size)
            |> RoundCornerImageProcessor(cornerRadius: 30)
        tagImageView.kf.indicatorType = .activity
        tagImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "imgHolder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
//        {
//            result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//            }
//        }
    }
}
