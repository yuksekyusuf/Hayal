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
    var isSearching: Bool { get set }
}

class PhotosInteractor: PhotosInteracting {
    
    
    let cache = NSCache<NSString, UIImage>()
    let service: PhotoServicing
    var photos = [Photo]()
    var isSearching: Bool = false
    weak var viewController: SearchViewControlling?
    var workItem: DispatchWorkItem?
    
    init(service: PhotoServicing) {
        self.service = service
    }
    
    func getPhotos(tag: String, page: Int) {
        let delayInMilliSeconds: Int = 400
        var preWorkItem = workItem
        workItem?.cancel()
        
        var myWorkItem: DispatchWorkItem?
        myWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.service.fetchPhotos(for: tag, page: page) { result in
                if let workItem = myWorkItem, !workItem.isCancelled {
                    switch result {
                    case .success(let photosData):
                        self.photos = photosData.photos.photo
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
    
    
    
    func setCell(photo: Photo, photoImage: UIImageView) {
        let url = "https://live.staticflickr.com/"+"\(photo.server)/" + "\(photo.id)" + "_\(photo.secret)_q.jpg"
        service.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                photoImage.image = image
            }
        }
    }
    
    
    func cancelButtonTapped() {
        isSearching = false
        self.viewController?.updateData(on: photos)
    }
    
    
  
    
    
}
