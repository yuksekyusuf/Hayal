//
//  PhotoServicew.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/11/22.
//

import UIKit

class PhotoService {
    private let url = "https://api.flickr.com/services/rest/?format=json&method=flickr.photos.search&api_key=5379a3eda00bd01a30d2c95543a55e77&tags=%27+cat+%27&nojsoncallback=1"
    
    static let shared = PhotoService()
    
    func getPhotos(completion: @escaping (Result<Root, Error>) -> Void) {
        
        let endpoint = url
        print(url)
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(error as! Error))
                
                print("\(error?.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(error as! Error))
                print("\(error?.localizedDescription)")
                return
            }
            
            guard let data = data else {
                completion(.failure(error as! Error))
                print("\(error?.localizedDescription)")

                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photos = try decoder.decode(Root.self, from: data)
                completion(.success(photos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
