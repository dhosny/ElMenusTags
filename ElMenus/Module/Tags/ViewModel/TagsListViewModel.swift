//
//  TagsListViewModel.swift
//  ElMenus
//
//  Created by Dalia Hosny on 1/20/20.
//  Copyright © 2020 Dalia Hosny. All rights reserved.
//

import Foundation

public enum State {
    case loading
    case error
    case empty
    case loaded
}

class TagsListViewModel{
    
    let tagGateway: TagGateway
    
    private var tagsList: [Tag] = [Tag]()
    private var pageNumber: Int = 1
    
    private var tagCellViewModels: [TagsListCellViewModel] = [TagsListCellViewModel]() {
        didSet {
            self.reloadTagsViewClosure?()
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
    
    var numberOfTagsCells: Int {
        return tagsList.count
    }
    
    var selectedTag: Tag?
    
    var reloadTagsViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(tagGateway: TagGateway = TagGatewayImp()) {
        self.tagGateway = tagGateway
    }
    
    func initFetch() {
        state = .loading
        tagGateway.getTags(In: pageNumber){ [weak self] (tags, msg, states) in
            guard let self = self else {
                return
            }
            
            guard states == .success else {
                self.state = .error
                self.alertMessage = msg
                return
            }
            
            self.state = .loaded
            self.processFetchedData(data: tags)
          
        }
    }
    
    func getTag(atIndex : Int) -> Tag{
        return self.tagsList[atIndex]
    }
    
    func getTagCellViewModel( at indexPath: IndexPath ) -> TagsListCellViewModel {
        return tagCellViewModels[indexPath.row]
    }
    
    func createTagCellViewModel(tag: Tag ) -> TagsListCellViewModel {
        
        return TagsListCellViewModel(name: tag.tagName, imgUrl: tag.photoURL) 
    }
    
    private func processFetchedData(data: [Tag] ) {
        self.tagsList = data // Cache
        var vms = [TagsListCellViewModel]()
        for item in data {
            vms.append(createTagCellViewModel(tag: item))
        }
        self.tagCellViewModels = vms
    }
    
}

extension TagsListViewModel {
    
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
//    func userPressed( at indexPath: IndexPath ){
//        
//        switch self.displayMode {
//        case .allCountries, .filteredCountries:
//            self.selectedCountry = nil
//            if (self.selectedCountriesList.count < 5){
//                if (!displayedCountriesList[indexPath.row].isSelected){
//                    //add to selected countries
//                    self.selectCountry(atIndex: indexPath.row)
//                } else {
//                    alertMessage = NSLocalizedString("Sorry: This country is already added", comment: "")
//                }
//                
//            } else {
//                alertMessage = NSLocalizedString("Sorry: You can't add more than 5 countries", comment: "")
//            }
//            
//        //self.displayMode = .selectedCountries
//        case .selectedCountries:
//            self.selectedCountry = displayedCountriesList[indexPath.row]
//            
//        }
//        
//    }
}
