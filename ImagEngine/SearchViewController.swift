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
    var isSearching: Bool = false
    enum Section { case main }
    var dataSource: UICollectionViewDiffableDataSource<Section, Photo>!
    var collectionView: UICollectionView!
    
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
        
    }
    
    @objc private func selectButtonTapped() {
        mMode = mMode == .view ? .select : .view
    }
    
    //MARK: - Configure CollectionView
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIFlowLayoutHelper.createThreeColumnLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseID)
        collectionView.allowsMultipleSelection = true
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
    
    func reloadData() {
        collectionView.reloadData()
    }
    
}

//MARK: - SearchBar Delegate

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
   
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let tag = searchController.searchBar.text else { return }
        if tag.isEmpty {
            return
        }
        interactor.getPhotos(tag: tag, page: 1)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        interactor.cancelButtonTapped()
    }
    
}
