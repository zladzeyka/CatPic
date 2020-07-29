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

    init(picture: CatPicture, isFavourite: Bool) {
        id = picture.id
        urlString = picture.url
        self.isFavourite = isFavourite
    }
}
