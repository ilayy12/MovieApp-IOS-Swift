//
//  FavoritesDataBase.swift
//  Movies
//
//  Created by aytü on 2.08.2022.
//

import Foundation

class UDM {
    static let shared = UDM()
    let defaults = UserDefaults()
    var favs: [String] = []
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    func reachKeys() {
        if isKeyPresentInUserDefaults(key: "allKeys") != false {
            if favs.isEmpty == false {
                favs.removeAll()
            }
            favs = UDM.shared.defaults.stringArray(forKey: "allKeys")!
        }
    }
    
    func saveKeys() {
        if favs.isEmpty == false {
            defaults.set(favs, forKey: "allKeys")
        } else {
            defaults.removeObject(forKey: "allKeys")
        }
    }
    
    func appendKey(id: String) {
        favs.append(id)
    }
    
    func removeKey(id: String) {
        if let index = favs.firstIndex(of: id) {
            favs.remove(at: index)
        }
    }
}
