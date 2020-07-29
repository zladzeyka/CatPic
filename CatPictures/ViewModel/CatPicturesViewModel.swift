//
//  CatPicturesViewModel.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 22.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
class CatPicturesViewModel {

    var onErrorHandling: ((String?) -> Void)?
    
    var pictures: [CatPicture] = []
    private(set) var dataSource = GenericDataSource<CatCellViewModel>()
    
    func loadRandomPictures() {
        ApiHelper.shared.onErrorHandling = { error in
            self.onErrorHandling!(error?.errorDescription)
        }
        ApiHelper.shared.requestPictures { [weak self] (pics: [CatPicture]) in
            if !pics.isEmpty {
                self?.pictures = pics
                self?.reloadCachedPictures()
            }
        }
    }
    
    func reloadCachedPictures() {
        let pics = self.pictures
        DispatchQueue.global().async { [weak self] in
            let models: [CatCellViewModel] = pics.map { pic in
                let vm = CatCellViewModel(picture: pic, isFavourite: CoreDataHelper.shared.wasSaved(pic: pic))
                
                vm.onFavouriteHandling = { [weak vm] in
                    guard let vm = vm else { return }
                    if (vm.isFavourite) {
                        CoreDataHelper.shared.deletePicture(picture: pic)
                        vm.isFavourite = false
                        ImageCacheHelper.shared.removeFromCache(pic: pic)
                    } else {
                        CoreDataHelper.shared.savePicture(picture: pic)
                        vm.isFavourite = true
                        ImageCacheHelper.shared.saveToCache(pic: pic)
                    }
                }
                return vm
            }
            
            DispatchQueue.main.async { [weak self] in
                if !pics.isEmpty {
                    self?.dataSource.data.value = models
                }
            }
        }
    }
}
