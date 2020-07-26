//
//  SavedCatCell.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 24.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
import UIKit
class SavedCatCell: UICollectionViewCell {
    var viewModel: SavedCellViewModel? {
        didSet {
            if let vm = viewModel {
               let url = vm.urlString
               // let cachedImage = ImageCacheHelper.shared.cachedImage(identifier: vm.id)
               // iconImageView.image = cachedImage
                iconImageView.af_setImage(
                    withURL: URL(string: url)!,
                    placeholderImage: UIImage(),
                    filter: nil,
                    imageTransition: .crossDissolve(0.2))
                favButton.buttonState = FavouriteButton.ButtonState.saved
                favButton.action = {
                    
                    vm.onDeleteHandling()
                }
            }
        }
    }

    @IBOutlet var iconImageView: UIImageView!

    @IBOutlet var favButton: FavouriteButton!
}
