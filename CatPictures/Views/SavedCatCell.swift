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
    @IBOutlet var iconImageView: UIImageView!

    @IBOutlet var favButton: FavouriteButton!
    var viewModel: SavedCellViewModel? {
        didSet {
            if let vm = viewModel {
                let url = vm.urlString
                if let image = ImageCacheHelper.shared.cachedImage(identifier: vm.urlString) {
                    iconImageView.image = image
                } else {
                    if let image = ImageCacheHelper.shared.loadImageFromDiskWith(fileName: vm.id) {
                        iconImageView.image = image
                    } else {
                        iconImageView.af.setImage(withURL: URL(string: url)!)
                    }
                }
                favButton.buttonState = FavouriteButton.ButtonState.saved
                favButton.action = {
                    vm.onDeleteHandling()
                }
            }
        }
    }
}
