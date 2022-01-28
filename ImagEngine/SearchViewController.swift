//
//  SearchViewController.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

protocol SearchViewControlling: AnyObject {
    func updateData(on photos: [Photo])
    var hasMorePhotos: Bool { get set }
    var page: Int { get set }
}

class SearchViewController: UIViewController, SearchViewControlling {
    
    var searchTag: String!
    var page = 1
    var hasMorePhotos = true
    var isSearching: Bool = false
    enum Section { case main }
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var collectionView: UICollectionView!
    var dictionarySelectedIndexPath = [IndexPath: Bool]()
    var arraySelectedIndexPaths = [Int]()
    var selectedPhotos = [Photo]()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        return button
    }()
    
    lazy var selectButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonTapped))
        return button
    }()
    
    enum Mode {
        case view
        case select
    }
    
    var mMode: Mode = .view {
        didSet {
            switch mMode {
            case .view:
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                selectButton.title = "Select"
                collectionView.allowsMultipleSelection = false
            case .select:
                selectButton.title = "Cancel"
                collectionView.allowsMultipleSelection = true
            }
        }
    }
    
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
        configureCollectionView()
        configureDataSource()
        configureSearchBar()
        configureUI()
    }

    
   //MARK: - UIConfiguration
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = selectButton
        
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for  an Image"
        navigationItem.searchController = searchController
    }
    
    @objc private func addButtonTapped() {
        for (key, value) in dictionarySelectedIndexPath {
            if value {
                arraySelectedIndexPaths.append(key.row)
            }
        }
        let photos = interactor.selectPhotos(for: arraySelectedIndexPaths)
        
        for photo in photos {
            let photo = Photo(id: photo.id, owner: photo.owner, secret: photo.secret, server: photo.server, farm: photo.farm, title: photo.title, ispublic: photo.ispublic, isfriend: photo.isfriend, isfamily: photo.isfamily)
            PersistanceManager.updateWith(favorite: photo, actionType: .add) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    let alert = UIAlertController(title: "Success!", message: "You successfully favorited these photos", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return }
                
                let alert = UIAlertController(title: "Something went wrong!", message: error.rawValue, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
    
            }
        }
        

    }
    
    @objc private func selectButtonTapped() {
        mMode = mMode == .view ? .select : .view
//        selectedPhotos = photos[selectedIndexPath]
        
    }
    
    //MARK: - Configure CollectionView
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIFlowLayoutHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        collectionView.delegate = self
    }
    
    
    //MARK: - Data Source
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(
            collectionView: collectionView, cellProvider: { (collectionView, indexPath, photo) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseID, for: indexPath) as? PhotoCell else {
                    fatalError("DequeueReusableCell failed while casting")
                }
                print(indexPath.row)
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
        print("DEBUG: snapshot", snapShot.numberOfItems)
        self.dataSource.applySnapshotUsingReloadData(snapShot)
    }
    
    
    
    
}

//MARK: - SearchBar Delegate

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
   
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let tag = searchController.searchBar.text, !tag.isEmpty else { return }
        searchTag = tag
        interactor.getPhotos(tag: tag, page: page)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        interactor.cancelButtonTapped()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard let tag = searchBar.text else { return }
//        searchTag = tag
//        interactor.getPhotos(tag: tag, page: 1)
//
//    }
    
}


extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch mMode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
//            let vc = interactor.cellTapped(on: indexPath)
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .popover
//            present(nav, animated: true)
//            perform something
        case .select:
            dictionarySelectedIndexPath[indexPath] = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mMode == .select {
            dictionarySelectedIndexPath[indexPath] = false
        }
    }
    
    //MARK: - Configure Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePhotos else { return }
            self.page += 1
            print("DEBUG: ", searchTag, page)
            interactor.getPhotos(tag: searchTag, page: page)
        }
    }
}
