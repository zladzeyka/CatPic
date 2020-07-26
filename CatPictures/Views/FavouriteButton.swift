//
//  FavouriteButton.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 23.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
import UIKit

class FavouriteButton: UIButton {
    enum ButtonState {
        case save
        case saved
    }
    enum Constants {
        static let saveImage = "heart"
        static let deleteImage = "heart.fill"
    }

    var buttonState : ButtonState = .save  {
        didSet {
             let buttonImage = (buttonState == .save) ? SaveButtonImages.save.saveImage : SaveButtonImages.delete.saveImage
            setImage(buttonImage, for: .normal)
            setImage(buttonImage, for: .highlighted)
            
        }
    }
    var action: () -> () = {}
    enum SaveButtonImages {
        case save
        case delete
        var saveImage: UIImage {
            switch self {
            case .save: return UIImage(systemName: Constants.saveImage) ?? UIImage()
            case .delete: return UIImage(systemName: Constants.deleteImage) ?? UIImage()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveButtonTapped)))
    }

    @objc func saveButtonTapped() {
        print(buttonState)
        action()

        buttonState = (buttonState == .save) ? .saved : .save
 print(buttonState)

        
    }
}
