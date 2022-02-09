//
//  FavoritesViewController.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate{
    
    var photos = [Photo]()
    enum Section { case main }
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var collectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getSavedPhotos()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIFlowLayoutHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(
            collectionView: collectionView, cellProvider: { (collectionView, indexPath, photo) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as? PhotoCell else {
                    fatalError("DequeueReusableCell failed while casting")
                }
                cell.setCell(justPhoto: photo)
                return cell
            }
        )
    }
    
    func updateData(on photos: [Photo]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
        snapShot.appendSections([.main])
        snapShot.appendItems(photos)
        print("DEBUG: snapshot", snapShot.numberOfItems)
        DispatchQueue.main.async {
            self.dataSource.applySnapshotUsingReloadData(snapShot)
        }
        
    }
    
    
    
    private func getSavedPhotos() {
        PersistanceManager.retriveSaves { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let savedPhotos):
                if savedPhotos.isEmpty {
                    print("No saved photos")
                } else {
                    self.photos = savedPhotos
                    self.updateData(on: self.photos)
                    print("DEBUG saved photos: ", self.photos.count)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension FavoritesViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.collectionView.reloadData()
    }
}
