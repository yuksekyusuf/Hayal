//
//  ImageCache.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/20/22.
//

import Foundation


protocol ImageCaching {
    
    func set(key: String, value: Data)
    func get(key: String) -> Data?
    func delete(key: String) -> Bool
    
}


class ImageCache: ImageCaching {
    
    var cacheDictionary: Dictionary<String, Data> = [:]
    
    
    func set(key: String, value: Data) {
        cacheDictionary[key] = value
    }
    
    func get(key: String) -> Data? {
        return cacheDictionary[key] ?? nil
    }
    
    func delete(key: String) -> Bool {
        cacheDictionary.removeValue(forKey: key)
        return cacheDictionary[key] == nil ? true : false
    }
}
