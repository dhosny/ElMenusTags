//
//  ItemTableViewCell.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/20/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import UIKit
import Kingfisher
import Hero

class ItemTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "ItemCellID"
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!

    var cellVM : ItemsListCellViewModel? {
        didSet {
            nameLbl.text = cellVM?.titleText
            self.setImg(url: cellVM?.imageUrl)
            imgView.heroID = "itemCellHeroId-\(cellVM?.id ?? 0)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
