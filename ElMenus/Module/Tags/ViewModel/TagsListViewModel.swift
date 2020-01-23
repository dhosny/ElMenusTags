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
    private var canLoadNextPage: Bool = true
    
    private var tagCellViewModels: [TagsListCellViewModel] = [TagsListCellViewModel]() {
        didSet {
            self.reloadTagsViewClosure?()
        }
    }
    
    var itemsViewModel: ItemsListViewModel?
    
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
    
    var selectedTag: Tag?{
        didSet {
            itemsViewModel?.tagName = selectedTag?.tagName
            //self.reloadItemsViewClosure?()
        }
    }
    
    var reloadTagsViewClosure: (()->())?
    var reloadItemsViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init(tagGateway: TagGateway = TagGatewayImp()) {
        self.tagGateway = tagGateway
    }
    
    func initFetch() {
        state = .loading
        tagsList = []
        pageNumber = 1
        canLoadNextPage = true
        loadData(page: pageNumber)
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
    
    
    func createItemViewModel() -> ItemsListViewModel {
        itemsViewModel = ItemsListViewModel()
        return itemsViewModel!
    }
    
    //load next page
    func loadNextPage() {
        if canLoadNextPage {
            canLoadNextPage = false
            pageNumber += 1
            loadData(page: pageNumber)
        }
    }
    
    private func loadData(page: Int) {
        state = .loading
        tagGateway.getTags(In: page){ [weak self] (success, tags, error, dataMode)  in
            guard let self = self else {
                return
            }
            guard success else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }
            
            self.state = .loaded
            self.processFetchedData(data: tags)
            
        }
    }
    private func processFetchedData(data: [Tag] ) {
        
        self.canLoadNextPage = (data.count > 0)
        self.tagsList.append(contentsOf: data)  // Cache
        var vms = [TagsListCellViewModel]()
        for item in data {
            vms.append(createTagCellViewModel(tag: item))
        }
        
        self.tagCellViewModels.append(contentsOf: vms)
        
        if selectedTag == nil {
            if data.count > 0 {
                selectedTag = data[0]
            }
        }
    }
}

extension TagsListViewModel {
    
    func userPressed(at indexPath: IndexPath ){
        selectedTag = tagsList[indexPath.row]
    }
}
