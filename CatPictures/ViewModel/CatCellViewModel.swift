//
//  CatCellViewModel.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 23.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
class CatCellViewModel {
    let id: String
    let urlString:String
    var isFavourite : Bool = false
    var onFavouriteHandling: () -> () = {}

    init(picture: CatPicture) {
        id = picture.id
        urlString = picture.url
    
        isFavourite = (CoreDataHelper.shared.wasSaved(pic: picture))
        onFavouriteHandling = {
            if (self.isFavourite) {
                CoreDataHelper.shared.deletePicture(picture: picture)
               self.isFavourite = false
               // ImageCacheHelper.shared.removeCachedImage(identifier: picture.id)
            } else {
                CoreDataHelper.shared.savePicture(picture: picture)
                self.isFavourite = true
              //  ImageCacheHelper.shared.cacheImage(pic: picture)
            }
            
        }
    }
}
