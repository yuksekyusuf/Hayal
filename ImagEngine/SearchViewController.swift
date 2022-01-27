//
//  SearchViewController.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

protocol SearchViewControlling: AnyObject {
    func updateData(on photos: [Photo])
    var searchTag: String! { get }
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
        print(photos)
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
        self.dataSource.apply(snapShot, animatingDifferences: true)
        
    }
}

//MARK: - SearchBar Delegate

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
   
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let tag = searchController.searchBar.text else { return }
        searchTag = tag
        if tag.isEmpty {
            return
        }
        interactor.getPhotos(tag: tag, page: 1)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        interactor.cancelButtonTapped()
    }
    
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
        interactor.scrollDown(scrollView)
    }
}
