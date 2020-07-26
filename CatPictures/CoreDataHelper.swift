//
//  CoreDataHelper.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 23.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import CoreData
import Foundation
import UIKit

class CoreDataHelper {
    struct Constants {
        static let entityName = "CatPic"
        static let id = "id"
    }
    
    static let shared = CoreDataHelper()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let privateManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return moc
    }()
    
    func retrieveSavedPictures() -> [CatPicture] {
        var pictures: [CatPicture] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.id, ascending: true)]
        
        do {
            let results = try managedContext.fetch(fetchRequest) as! [CatPic]
            for object in results {
                let id = object.id!
                let urlString = object.urlString!
                let catPicture = CatPicture(id: id, url: urlString)
                
                pictures.append(catPicture)
            }
        }
        catch {
            print(error)
        }
        return pictures
    }
    
    func savePicture(picture: CatPicture) {
        do {
            if !wasSaved(pic: picture) {
                let catPic = CatPic(entity: CatPic.entity(), insertInto: managedContext)
                catPic.id = picture.id
                catPic.urlString = picture.url
                try managedContext.save()
            }
        }
        catch {
            print(error)
        }
    }
    
    func deletePicture(picture: CatPicture) {
        var results: [CatPic] = []
        
        let fetchRequest = buildFetchRequestForPicture(pic: picture)
        do {
            results = try managedContext.fetch(fetchRequest) as! [CatPic]
            if !results.isEmpty {
                if let deletedPic = results.first {
                    managedContext.delete(deletedPic)
                    try managedContext.save()
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func wasSaved(pic: CatPicture) -> Bool {
        var count = 0
        
        let fetchRequest = buildFetchRequestForPicture(pic: pic)
        do {
            count = try managedContext.count(for: fetchRequest)
        }
        catch {
            print(error)
        }
        return count > 0
    }
    
    func buildFetchRequestForPicture(pic: CatPicture) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        let predicate =  NSPredicate(format: "id == %@", pic.id)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
