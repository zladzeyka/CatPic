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
    var viewModel: CatCellViewModel? {
         didSet {
                    if let vm = viewModel {
//                        if vm.isFavourite {
//                            DispatchQueue.main.async {
//                            let image = ImageCacheHelper.shared.cachedImage(identifier: vm.id)
//                                self.iconImageView.image = image
//                            }
//                        } else {
                        let url = vm.urlString
                        iconImageView.af_setImage(
                            withURL: URL(string: url)!,
                            placeholderImage: UIImage(),
                            filter: nil,
                            imageTransition: .crossDissolve(0.2))
   //                     }
                        favButton.buttonState = vm.isFavourite ? FavouriteButton.ButtonState.saved : FavouriteButton.ButtonState.save
                        favButton.action = {
                            vm.onFavouriteHandling()
                        }
                  }
    }
    }
    @IBOutlet var iconImageView: UIImageView!

    @IBOutlet var favButton: FavouriteButton!
}
