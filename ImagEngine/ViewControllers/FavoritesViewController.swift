//
//  FavoritesViewController.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

class FavoritesViewController: UICollectionViewController {
    
    var photos = [SavedPhoto]()
    var groupedPhotos : [String: [SavedPhoto]] = [:]
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSavedPhotos()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Saves"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        collectionView.register(CellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func getSavedPhotos() {
        PersistanceManager.read { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let savedPhotos):
                if savedPhotos.isEmpty {
                    print("No saved photos")
                } else {
                    self.photos = savedPhotos
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.view.bringSubviewToFront(self.collectionView)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        groupedPhotos = Dictionary(grouping: photos, by: { $0.searchTag })
        collectionView.reloadData()
    }
}

extension FavoritesViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupedPhotos.keys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedPhotos[Array(groupedPhotos.keys)[section]]!.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photos = groupedPhotos[Array(groupedPhotos.keys)[indexPath.section]]
        let photo = photos![indexPath.row]
        
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as? PhotoCell else {
            fatalError("DequeueReusableCell failed while casting")
        }
        cell.setCell(justPhoto: photos![indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CellHeader
        let category = Array(groupedPhotos.keys)[indexPath.section]
        header.label.text = category
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }

}
extension FavoritesViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.collectionView.reloadData()
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let padding: CGFloat = 2
        let minimumSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumSpacing * 2)
        let itemWidth = availableWidth / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}
