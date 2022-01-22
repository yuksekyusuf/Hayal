//
//  PhotoServicew.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

protocol PhotoServicing {
    func fetchPhotos(for tag: String, page: Int, completion: @escaping (Result<Root, Error>) -> Void)
//    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void)
}

class PhotoService: PhotoServicing {
//
//    static let shared = PhotoService()
    
//    let cache = NSCache<NSString, UIImage>()
    
    private let baseUrl = "https://api.flickr.com/services/rest/?format=json&method=flickr.photos.search&api_key="
    
    func fetchPhotos(for tag: String, page: Int, completion: @escaping (Result<Root, Error>) -> Void) {
        let key = "5379a3eda00bd01a30d2c95543a55e77"
        let endpoint = baseUrl + "\(key)" + "&tags=%27+\(tag)+%27" + "&nojsoncallback=\(page)"
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error as! Error))
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(error as! Error))
                print(error)
                return
            }
            
            guard let data = data else {
                completion(.failure(error as! Error))
                print(error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photos = try decoder.decode(Root.self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
                print(error)
            }
        }
        task.resume()
    }
//    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
//        let cacheKey = NSString(string: url)
//        guard let url = URL(string: url) else {
//            completion(nil)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            guard let self = self,
//                  error == nil,
//                  let response = response as? HTTPURLResponse, response.statusCode == 200,
//                  let data = data,
//                  let image = UIImage(data: data) else {
//                      completion(nil)
//                      return
//                  }
//            
//            self.cache.setObject(image, forKey: cacheKey)
//            completion(image)
//        }
//        task.resume()
//    }
    
}
