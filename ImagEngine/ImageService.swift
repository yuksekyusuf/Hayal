//
//  ImageService.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/20/22.
//

import Foundation

class ImageService {
    
    let cache = ImageCache()
    let filesManager = FilesManager()
    
    func downloadImage(from url: String, completion: @escaping (Data) -> Void) {
        let cacheKey = NSString(string: url)
        guard let url = URL(string: url) else { return }
        
        do {
            let data = try filesManager.read(fileNamed: "images")
            completion(data)
        } catch {
            
        }
        if cache.cacheDictionary.capacity == 100 {
            guard let key = cache.cacheDictionary.first?.key else { return }
            let result = cache.delete(key: key)
            print("Deleted urls are \(key)")
        } else {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      error == nil,
                      let response = response as? HTTPURLResponse, response.statusCode == 200,
                      let data = data else {
                          return
                      }
                
                self.cache.set(key: cacheKey as String, value: data)
                try? self.filesManager.save(fileNamed: "images", data: data)
                
                
                DispatchQueue.main.async {
                    completion(data)
                    print(self.cache.cacheDictionary)
                    print(self.cache.cacheDictionary.capacity)
                }
            }
            task.resume()
        }
    }
}
