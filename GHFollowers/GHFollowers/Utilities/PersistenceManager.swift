//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 12.08.2021.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    enum PersistenceActionType {
        case add, remove
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GHFError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                if actionType == PersistenceActionType.add {
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                } else if actionType == PersistenceActionType.remove {
                    favorites.removeAll(where: { $0.login == favorite.login })
                }
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GHFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let favorites = try JSONDecoder().decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.defaultsError))
        }
    }
    
    static func save(favorites: [Follower]) -> GHFError? {
        do {
            let encoded = try JSONEncoder().encode(favorites)
            defaults.set(encoded, forKey: Keys.favorites)
            return nil
        } catch {
            return .defaultsError
        }
    }
}
