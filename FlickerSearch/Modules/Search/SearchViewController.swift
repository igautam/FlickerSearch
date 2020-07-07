//
//  SearchViewController.swift
//  FlickerSearch
//
//  Created by RAJESH KUMAR on 27/06/20.
//  Copyright © 2020 RAJESH KUMAR. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var photoCollectionView: UICollectionView?
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindWithViewModel()
        
//        viewModel.search(searchText: <#T##String#>, completion: <#T##() -> Void#>)
//        viewModel.search(with: "fruits") {
//            self.photoCollectionView?.reloadData()
//        }
        // Do any additional setup after loading the view.
    }
    
    func bindWithViewModel() {
        viewModel.paginationRes.bind { [weak self] _ in
            self?.photoCollectionView?.reloadData()
        }
        viewModel.error.bind { [weak self] (error: String?) in
            self?.showAlertWithTitle("Error", message: error!)
        }
    }
    
    func configureCollectionView() {
        photoCollectionView?.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        photoCollectionView?.delegate = self
        photoCollectionView?.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width/2, height: 250)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        photoCollectionView?.collectionViewLayout = layout
    
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath)
            as? PhotoCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            viewModel.loadMorePhotos()
        }
        if let photo = viewModel.photoForIndex(index: indexPath.row) {
            (cell as! PhotoCollectionViewCell).photoImageView?.image = UIImage(named: "placeholder")
            ImageDownloadManager.shared.downloadImage(photo, indexPath: indexPath) { (image, url, indexPathh, error) in
                if let indexPathNew = indexPathh {
                    DispatchQueue.main.async {
                        if let getCell = collectionView.cellForItem(at: indexPathNew) {
                            (getCell as? PhotoCollectionViewCell)!.photoImageView?.image = image
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /* Reduce the priority of the network operation in case the user scrolls and an image is no longer visible. */
        if self.viewModel.loadMore { return }
        if let photo = viewModel.photoForIndex(index: indexPath.row) {
            ImageDownloadManager.shared.slowDownImageDownloadTaskFor(photo)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModel.loadMore = true
        guard let searchText = searchBar.text, searchText.count > 0 else {
            ImageDownloadManager.shared.cancelAll()
            self.viewModel.clearSearch()
            self.photoCollectionView?.reloadData()
            return
        }
        viewModel.clearSearch()
        viewModel.search(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
