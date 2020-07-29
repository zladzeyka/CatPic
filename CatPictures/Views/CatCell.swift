//
//  CatCell.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 22.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit
class CatCell: UICollectionViewCell {
    @IBOutlet var iconImageView: UIImageView!

    @IBOutlet var favButton: FavouriteButton!
    
    var viewModel: CatCellViewModel? {
        didSet {
            if let vm = viewModel {
                let url = vm.urlString

                if vm.isFavourite {
                    DispatchQueue.main.async {
                        if let image = ImageCacheHelper.shared.cachedImage(identifier: vm.urlString) {
                            self.iconImageView.image = image
                        } else {
                            if let image = ImageCacheHelper.shared.loadImageFromDiskWith(fileName: vm.id) {
                                self.iconImageView.image = image
                            } else {
                                let url = vm.urlString
                                self.iconImageView.af.setImage(withURL: URL(string: url)!)
                            }
                        }
                    }
                } else {
                    iconImageView.af.setImage(withURL: URL(string: url)!)
                }
                favButton.buttonState = vm.isFavourite ? FavouriteButton.ButtonState.saved : FavouriteButton.ButtonState.save
                favButton.action = {
                    vm.onFavouriteHandling()
                }
            }
        }
    }


}
