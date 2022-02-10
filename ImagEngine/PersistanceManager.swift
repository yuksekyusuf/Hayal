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
    
    
    static func save(favorites: [SavedPhoto]) -> CustomError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    static func read(completion: @escaping(Result<[SavedPhoto], CustomError>) -> Void) {
        guard let savesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let saves = try decoder.decode([SavedPhoto].self, from: savesData)
            completion(.success(saves))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func updateWith(saves: [Photo], for searchTag: String, actionType: PersistanceActionType, completion: @escaping (CustomError?) -> Void) {

        read { result in
            switch result {
            case .success(let favorites):
                var retrivedSaves = favorites
                
                for myPhoto in saves {
                    let photo = SavedPhoto(searchTag: searchTag, url: myPhoto.url)
                    switch actionType {
                    case .add:
                        guard !retrivedSaves.contains(photo) else {
                            completion(.alreadyInFavorite)
                            return
                        }
                        retrivedSaves.append(photo)
                        completion(save(favorites: retrivedSaves))
                    case .remove:
                        retrivedSaves.removeAll { $0.url == photo.url }
                    }
                }
            
                
            case .failure(let error):
                completion(error)
            }
        }
    }
}
