//
//  SearchViewController.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

protocol SearchViewControlling: AnyObject {
    func updateData(on photos: [Photo])
}

class SearchViewController: UIViewController, SearchViewControlling {
    
    var tag: String!
    var page = 1
    var collectionView: UICollectionView!
    enum Section { case main }
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    
    
    var interactor: PhotosInteractor
    init(interactor: PhotosInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        interactor.getPhotos(tag: tag, page: page)
        configureCollectionView()
        configureDataSource()
        
    }
    
   //MARK: - UIConfiguration
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    //MARK: - Configure CollectionView
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIFlowLayoutHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
    }
    
    
    //MARK: - Data Source
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(
            collectionView: collectionView, cellProvider: { (collectionView, indexPath, photo) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as? PhotoCell else {
                    fatalError("DequeueReusableCell failed while casting")
                }
                cell.interactor = self.interactor
                cell.setCell(photo: photo)
                return cell
            }
        )
    }
    
    func updateData(on photos: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapShot.appendSections([.main])
        snapShot.appendItems(photos)
        self.dataSource.apply(snapShot, animatingDifferences: true)
    }
    
//    func reloadData() {
//        collectionView.reloadData()
//    }


}
