//
//  CoreDataHelperTests.swift
//  CatPicturesTests
//
//  Created by Nadzeya Karaban on 27.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

@testable import CatPictures
import CoreData
import XCTest
class CoreDataHelperTests: XCTestCase {
    var coreDataHelper: CoreDataHelper!
       var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    override func setUpWithError() throws {
        super.setUp()
        coreDataHelper = CoreDataHelper.shared
        coreDataHelper.persistentContainer = mockPersistantContainer
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    // MARK: CoreDataHelper test cases

    func test_init_coreDataHelper() {
        let instance = CoreDataHelper.shared
        /* Asserts that an expression is not nil.
         Generates a failure when expression == nil. */
        XCTAssertNotNil(instance)
    }

    func test_retrieveSavedPictures() {
        coreDataHelper.retrieveSavedPictures { result in
            switch result {
            case .success(let pics):
                XCTAssertGreaterThan(pics.count, 0)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func test_savePicture() {
        var catPics: [CatPicture] = []
        coreDataHelper.retrieveSavedPictures { result in
            switch result {
            case .success(let pics):
                catPics.append(contentsOf: pics)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        let numberOfItems = catPics.count

        if numberOfItems > 0 {
            let imageToSave = catPics[0]
            coreDataHelper.savePicture(picture: imageToSave)
        }

        var newNumberOfItems = 0
        coreDataHelper.retrieveSavedPictures { newResult in
            switch newResult {
            case .success(let pics):
                newNumberOfItems = pics.count
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        XCTAssertEqual(newNumberOfItems, numberOfItems)
    }
}
