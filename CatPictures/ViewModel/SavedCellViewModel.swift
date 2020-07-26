//
//  SavedCellViewModel.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 24.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
class SavedCellViewModel {
    let id: String
    let urlString: String
    var onDeleteHandling: () -> Void = {}

    init(picture: CatPicture, action: @escaping () -> Void) {
        id = picture.id
        urlString = picture.url
        onDeleteHandling = action
    }
}
