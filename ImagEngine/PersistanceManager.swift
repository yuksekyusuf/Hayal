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
    
    static func updateWith(saves: [Photo], actionType: PersistanceActionType, completion: @escaping (CustomError?) -> Void) {

        retriveSaves { result in
            switch result {
            case .success(let favorites):
                var retriveSaves = favorites
                
                for photo in saves {
                    let photo = Photo(id: photo.id, owner: photo.owner, secret: photo.secret, server: photo.server, farm: photo.farm, title: photo.title, ispublic: photo.ispublic, isfriend: photo.isfriend, isfamily: photo.isfamily)
                    guard !retriveSaves.contains(photo) else {
                        completion(.alreadyInFavorite)
                        return
                    }
                    
                    retriveSaves.append(photo)
                    completion(save(favorites: retriveSaves))
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    static func retriveSaves(completion: @escaping(Result<[Photo], CustomError>) -> Void) {
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
