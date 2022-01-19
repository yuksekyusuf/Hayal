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
    var photos: [Photo] { get }
}

class PhotosInteractor: PhotosInteracting {
    
    
    let cache = NSCache<NSString, UIImage>()
    let service: PhotoServicing
    var photos = [Photo]()
    weak var viewController: SearchViewControlling?
    
    init(service: PhotoServicing) {
        self.service = service
    }
    
    func getPhotos(tag: String, page: Int) {
        service.fetchPhotos(for: tag, page: page) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photosData):
                self.photos = photosData.photos.photo
                self.viewController?.updateData(on: self.photos)
                if self.photos.isEmpty {
                    let message = "This endpoint has no data. Try another tag please!!!"
                    print(message)
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func setCell(photo: Photo, photoImage: UIImageView) {
        let url = "https://live.staticflickr.com/"+"\(photo.server)/" + "\(photo.id)" + "_\(photo.secret)_q.jpg"
        let cacheKey = NSString(string: url)
        if let image = cache.object(forKey: cacheKey) {
            photoImage.image = image
            print("Added to cache")
            return
        } else {
            service.downloadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    photoImage.image = image
                    print(url)
                }
            }
        }
        
    }
    
    
  
    
    
}
