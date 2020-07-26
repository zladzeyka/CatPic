//
//  ImageCacheHelper.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 26.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import AlamofireImage
import Foundation
class ImageCacheHelper {
    static let shared = ImageCacheHelper()
    var imagesCache = AutoPurgingImageCache()

    func cacheImage(pic: CatPicture) {
        if let catImageUrl = URL(string: pic.url) {
            do {
                let urlRequest = URLRequest(url: catImageUrl)

                let imageData = try Data(contentsOf: catImageUrl as URL)
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.imagesCache.add(image, for: urlRequest, withIdentifier: pic.id)
                    }
                }
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }

    func cachedImage(identifier: String) -> UIImage {
        let urlRequest = URLRequest(url: URL(string: identifier)!)
        let cachedImage = imagesCache.image(for: urlRequest, withIdentifier: identifier)
        return cachedImage ?? UIImage()
    }

    func removeCachedImage(identifier: String) {
        let urlRequest = URLRequest(url: URL(string: identifier)!)
        imagesCache.removeImage(for: urlRequest, withIdentifier: identifier)
    }
}
