//
//  CatPic+CoreDataProperties.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 23.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//
//

import Foundation
import CoreData


extension CatPic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CatPic> {
        return NSFetchRequest<CatPic>(entityName: "CatPic")
    }

    @NSManaged public var id: String?
    @NSManaged public var urlString: String?

}
