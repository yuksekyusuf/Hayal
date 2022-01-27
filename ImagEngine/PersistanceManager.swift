//
//  PersistanceManager.swift
//  ImagEngine
//
//  Created by Ahmet Yusuf Yuksek on 1/26/22.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    enum Keys {
        static let favorites = "favorites"
    }
    
    static private let defaults = UserDefaults.standard
    
    static func updateWith(favorites: Set<Photo>, actionType: PersistanceActionType, completion: @escaping (CustomError?) -> Void) {
        
        retriveFavorites { result in
            switch result {
            case .success(let favorites):
                completion(save(favorites: favorites))
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    static func retriveFavorites(completion: @escaping(Result<Set<Photo>, CustomError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode(Set<Photo>.self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: Set<Photo>) -> CustomError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
