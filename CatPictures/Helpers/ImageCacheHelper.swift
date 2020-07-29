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
    var imagesCache = AutoPurgingImageCache(memoryCapacity: 111_111_111, preferredMemoryUsageAfterPurge: 90_000_000)

    func cacheImage(pic: CatPicture) {
        if let catImageUrl = URL(string: pic.url) {
            do {
                let urlRequest = URLRequest(url: catImageUrl)

                let imageData = try Data(contentsOf: catImageUrl as URL)
                if let image = UIImage(data: imageData) {
                    imagesCache.add(image, for: urlRequest, withIdentifier: pic.url)
                }
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }

    func cachedImage(identifier: String) -> UIImage? {
        let urlRequest = URLRequest(url: URL(string: identifier)!)
        let cachedImage = imagesCache.image(for: urlRequest, withIdentifier: identifier)
        return cachedImage
    }

    func removeCachedImage(identifier: String) {
        let urlRequest = URLRequest(url: URL(string: identifier)!)
        imagesCache.removeImage(for: urlRequest, withIdentifier: identifier)
    }

    func saveImage(pic: CatPicture) {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }

        let fileName = pic.id
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        if let catImageUrl = URL(string: pic.url) {
            do {
                let imageData = try Data(contentsOf: catImageUrl as URL)
                if !(FileManager.default.fileExists(atPath: fileURL.path)) {
                    do {
                        try imageData.write(to: fileURL)
                    } catch {
                        print("error saving file with error", error)
                    }
                }
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }

    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let cacheDirectory = FileManager.SearchPathDirectory.cachesDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(cacheDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }

        return nil
    }

    func removeImageFromDisk(fileName: String) {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        // Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
    }

    func removeFromCache(pic: CatPicture) {
        removeCachedImage(identifier: pic.url)
        removeImageFromDisk(fileName: pic.id)
    }

    func saveToCache(pic: CatPicture) {
        cacheImage(pic: pic)
        saveImage(pic: pic)
    }
}
