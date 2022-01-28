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
    
    static func updateWith(favorite: Photo, actionType: PersistanceActionType, completion: @escaping (CustomError?) -> Void) {
        
        retriveFavorites { result in
            switch result {
            case .success(let favorites):
                
                var retriveFavorites = favorites
                switch actionType {
                case .add:
                    guard !retriveFavorites.contains(favorite) else {
                        completion(.alreadyInFavorite)
                        return
                    }
                    retriveFavorites.append(favorite)
                case .remove:
                    retriveFavorites.removeAll { $0.id == favorite.id }
                }
                
                completion(save(favorites: retriveFavorites))
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    static func retriveFavorites(completion: @escaping(Result<[Photo], CustomError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Photo].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Photo]) -> CustomError? {
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
