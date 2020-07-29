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
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func retrieveSavedPictures(completion: @escaping (Result<[CatPicture], Error>) -> ()) {
        let context = persistentContainer.newBackgroundContext()
        context.perform {
            var pictures: [CatPicture] = []
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: Constants.id, ascending: true)]
            
            do {
                let results = try context.fetch(fetchRequest) as! [CatPic]
                for object in results {
                    if let id = object.id, let urlString = object.urlString {
                        let catPicture = CatPicture(id: id, url: urlString)
                        pictures.append(catPicture)
                    }
                }
                DispatchQueue.main.async {
                    completion(.success(pictures))
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func savePicture(picture: CatPicture) {
        persistentContainer.viewContext.performAndWait {
            if !wasSaved(pic: picture) {
                let catPic = CatPic(entity: CatPic.entity(), insertInto: persistentContainer.viewContext)
                catPic.id = picture.id
                catPic.urlString = picture.url
                saveContext()
            }
        }
    }
    
    func deletePicture(picture: CatPicture) {
        var results: [CatPic] = []
        
        let fetchRequest = buildFetchRequestForPicture(pic: picture)
        
        persistentContainer.viewContext.performAndWait {
            do {
                results = try persistentContainer.viewContext.fetch(fetchRequest) as! [CatPic]
                if !results.isEmpty {
                    if let deletedPic = results.first {
                        persistentContainer.viewContext.delete(deletedPic)
                        try persistentContainer.viewContext.save()
                    }
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    func wasSaved(pic: CatPicture) -> Bool {
        var count = 0
        
        let fetchRequest = buildFetchRequestForPicture(pic: pic)
        persistentContainer.viewContext.performAndWait {
            do {
                count = try persistentContainer.viewContext.count(for: fetchRequest)
            }
            catch {
                print(error)
            }
        }
        return count > 0
    }
    
    func buildFetchRequestForPicture(pic: CatPicture) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        let predicate = NSPredicate(format: "id == %@", pic.id)
        fetchRequest.predicate = predicate
        return fetchRequest
    }
}
