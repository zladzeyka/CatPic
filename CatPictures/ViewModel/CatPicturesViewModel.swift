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

    var dataSource = CatPicturesDataSource()
    
    var numberOfSections: Int = 1
    var rowsPerSection: Int = 0


    func loadRandomPictures() {
        ApiHelper.shared.onErrorHandling = { error in
            self.onErrorHandling!(error?.errorDescription)
        }
        ApiHelper.shared.requestPictures { (pics: [CatPicture]) in
            if !pics.isEmpty {
                self.dataSource.data.value = pics
                self.rowsPerSection = pics.count
            }
        }
    }
    
    func viewModelForCell(at index: Int) -> CatCellViewModel {
        let pic = dataSource.data.value[index]
        return CatCellViewModel(picture: pic)
    }
    

}
