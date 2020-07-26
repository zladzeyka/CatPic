//
//  SavedPicturesViewModel.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 24.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
class SavedPicturesViewModel {
    var dataSource = CatPicturesDataSource()

    var numberOfSections: Int = 1
    var rowsPerSection: Int = 0
   // var onDeleteCompletion

    func loadSavedPictures() {
        dataSource.data.value = CoreDataHelper.shared.retrieveSavedPictures()
        rowsPerSection = dataSource.data.value.count
    }

    func viewModelForCell(at index: Int) -> SavedCellViewModel {
        let pic = dataSource.data.value[index]
        let onDelete = {
            self.remove(pic: pic)
            CoreDataHelper.shared.deletePicture(picture: pic)
           // ImageCacheHelper.shared.removeCachedImage(identifier: pic.id)
            let rowCount = self.dataSource.data.value.count
            self.rowsPerSection = rowCount

        }
        return SavedCellViewModel(picture: pic, action : onDelete)
    }

    func remove(pic: CatPicture) {
        if let index = dataSource.data.value.firstIndex(where: { $0.id == pic.id }) {
            dataSource.data.value.remove(at: index)
        }
    }
}
