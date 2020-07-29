//
//  SavedPicturesViewModel.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 24.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
class SavedPicturesViewModel {
    private(set) var dataSource = GenericDataSource<SavedCellViewModel>()
    var pictures: [CatPicture] = []

    func loadSavedPictures() {
        DispatchQueue.global().async { [weak self] in

            CoreDataHelper.shared.retrieveSavedPictures { [weak self] result in
                switch result {
                case .success(let pics):
                    self?.pictures = pics
                    let models: [SavedCellViewModel] = pics.map { pic in
                        let vm = SavedCellViewModel(picture: pic) {
                            self?.remove(pic: pic)
                            CoreDataHelper.shared.deletePicture(picture: pic)
                            ImageCacheHelper.shared.removeFromCache(pic: pic)
                        }
                        return vm
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.dataSource.data.value = models
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func remove(pic: CatPicture) {
        if let index = dataSource.data.value.firstIndex(where: { $0.id == pic.id }) {
            dataSource.data.value.remove(at: index)
        }
    }
}
