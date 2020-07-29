//
//  CatPicturesController.swift
//  CatPictures
//
//  Created by Nadzeya Karaban on 22.07.20.
//  Copyright © 2020 Nadzeya Karaban. All rights reserved.
//

import UIKit

class CatPicturesController: UIViewController {
    struct Constants {
        static let errorTitle = "We can'l load your data"
        static let errorMessage = "Sorry, something went wrong"
        static let cellIdentifier = "catCell"
        static let cPadding: CGFloat = 10.0
    }

    @IBOutlet var picturesCollection: UICollectionView!
    var viewModel = CatPicturesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        picturesCollection.dataSource = self
        picturesCollection.delegate = self

        viewModel.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.picturesCollection.reloadData()
            }
        }

        viewModel.onErrorHandling = { [weak self] error in
            self?.showError(Constants.errorTitle, message: error ?? Constants.errorMessage)
        }
        viewModel.loadRandomPictures()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.reloadCachedPictures()
    }
}

extension CatPicturesController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.data.value.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? CatCell {
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
