//
//  ItemsListCellViewModel.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/20/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import Foundation

class ItemsListCellViewModel {
    
    let titleText: String
    let imageUrl: String
    
    init(name: String, imgUrl: String) {
        self.titleText = name
        self.imageUrl = imgUrl
    }
    
}
