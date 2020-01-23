//
//  ItemsListViewModel.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/20/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import Foundation

class ItemsListViewModel {
    
    let tagGateway: TagGateway
    
    private var itemsList: [Item] = [Item]()
    var tagName: String? {
        didSet {
            self.initFetch()
        }
    }
    
    private var itemsCellViewModels: [ItemsListCellViewModel] = [ItemsListCellViewModel]() {
        didSet {
            self.reloadItemsViewClosure?()
        }
    }
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return itemsList.count
    }
    
    var selectedItem: Item?
    
    var reloadItemsViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(tagGateway: TagGateway = TagGatewayImp()) {
        self.tagGateway = tagGateway
        //self.tagName = tagName
    }
    
    func initFetch() {
        state = .loading
        tagGateway.getItems(By: tagName!){ [weak self] (success, items, error, dataMode) in
            guard let self = self else {
                return
            }
            
            guard success else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }
            
            self.state = .loaded
            self.processFetchedData(data: items)
            
        }
    }
    
    func getTag(atIndex : Int) -> Item{
        return self.itemsList[atIndex]
    }
    
    func getItemCellViewModel( at indexPath: IndexPath ) -> ItemsListCellViewModel {
        return itemsCellViewModels[indexPath.row]
    }
    
    func createItemCellViewModel(item: Item ) -> ItemsListCellViewModel {
        
        return ItemsListCellViewModel(id: item.id, name: item.name, imgUrl: item.photoUrl)
    }
    
    private func processFetchedData(data: [Item] ) {
        self.itemsList = data // Cache
        var vms = [ItemsListCellViewModel]()
        for item in data {
            vms.append(createItemCellViewModel(item: item))
        }
        self.itemsCellViewModels = vms
    }
    
}

extension ItemsListViewModel {
    
    //    func userPressedAddBtn(){
    //        self.displayMode = .allCountries
    //    }
    //
    //    func userPressedCancelAddBtn() {
    //        self.displayMode = .selectedCountries
    //    }
    //
    //    func userSearchedForCountry( searchTxt: String) {
    //        if searchTxt == "" {
    //            self.displayMode = .allCountries
    //
    //        } else {
    //            self.filteredCountriesList = countryGateway.getFilteredCountries(str: searchTxt)
    //            self.displayMode = .filteredCountries
    //
    //        }
    //
    //    }
    //
        func userPressed( at indexPath: IndexPath ){
            selectedItem = itemsList[indexPath.row]
        }
}
