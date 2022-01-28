//
//  Interactor.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/18/22.
//

import Foundation
import UIKit

protocol PhotosInteracting: AnyObject {
    func getPhotos(tag: String, page: Int)
    var photos: [Photo] { get set }
    var isSearching: Bool { get set }
//    var hasMorePhotos: Bool { get set }
    var selectedPhotos: Set<Photo> { get }
    func cellTapped(on indexPath: IndexPath) -> UIViewController
//    func scrollDown(_ scrollView: UIScrollView)
}

class PhotosInteractor: PhotosInteracting {
    
    
    let service: PhotoServicing
    let imageService: ImageService
    var photos = [Photo]()
    var isSearching: Bool = false
//    var page: Int = 1
    weak var viewController: SearchViewControlling?
    var workItem: DispatchWorkItem?
    var selectedPhotos = Set<Photo>()
    
    init(service: PhotoServicing, imageService: ImageService) {
        self.service = service
        self.imageService = imageService
    }
    
    func getPhotos(tag: String, page: Int) {
        let delayInMilliSeconds: Int = 1
        var preWorkItem = workItem
        workItem?.cancel()
        var myWorkItem: DispatchWorkItem?
        myWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.service.fetchPhotos(for: tag, page: page) { result in
                if let workItem = myWorkItem, !workItem.isCancelled {
                    switch result {
                    case .success(let photosData):
                        let fetchPhotos = photosData.photos.photo
                        if fetchPhotos.count < 100 { self.viewController?.hasMorePhotos = false }
                        self.photos += fetchPhotos
                        self.viewController?.updateData(on: self.photos)
                        if self.photos.isEmpty {
                            let message = "This endpoint had no data. Try another keyword please!!!"
                            print(message)
                        }
                    case .failure(let error):
                        print("\(error)")
                    }
                }
            }
        }
        self.workItem = myWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayInMilliSeconds), execute: workItem!)
    }
    
    func selectPhotos(for indexPath: [Int]) -> Set<Photo> {
        for item in indexPath {
            let photo = photos[item]
            selectedPhotos.insert(photo)
        }
        return selectedPhotos
    }
    
    
    
    func setCell(photo: Photo, photoImage: UIImageView) {
        let url = "https://live.staticflickr.com/"+"\(photo.server)/" + "\(photo.id)" + "_\(photo.secret)_q.jpg"
        let cache = imageService.cache
        if let data = cache.get(key: url) {
            photoImage.image = UIImage(data: data)
        } else {
            imageService.downloadImage(from: url) { [weak self] data in
                guard let self = self else { return }
                guard let image = UIImage(data: data) else { return }
                photoImage.image = image
            }
        }
    }
    
    
    func cancelButtonTapped() {
        isSearching = false
//        self.viewController?.updateData(on: photos)
    }
    
    func cellTapped(on indexPath: IndexPath) -> UIViewController {
        let photo = photos[indexPath.row]
        let viewController = FavoritesViewController()
        return viewController
    }
    
    
    
//    func scrollDown(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//        
//        if offsetY > contentHeight - height {
//            guard hasMorePhotos else { return }
//            self.page += 1
//            guard let searchTag = viewController?.searchTag else { return }
//            print("DEBUG: ", searchTag, page)
//            self.getPhotos(tag: searchTag, page: page)
//        }
//    }
}
