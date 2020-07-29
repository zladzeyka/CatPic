//
//  SavedPicturesViewController.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 22.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import UIKit

class SavedPicturesViewController: UIViewController {
    struct Constants {
        static let cellIdentifier = "savedCatCell"
        static let cPadding: CGFloat = 10.0
    }

    @IBOutlet var savedPicsCollection: UICollectionView!
    var viewModel = SavedPicturesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        savedPicsCollection.dataSource = self
        savedPicsCollection.delegate = self

        viewModel.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.savedPicsCollection.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadSavedPictures()
    }
}

extension SavedPicturesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.data.value.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? SavedCatCell {
            cell.viewModel = viewModel.dataSource.data.value[indexPath.row]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = collectionView.frame.width - Constants.cPadding
        return CGSize(width: itemSize / 2, height: itemSize / 2)
    }
}
