//
//  CatPicturesController+Utils.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 22.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import Foundation
import UIKit
extension CatPicturesController {
    func showError(_ title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
