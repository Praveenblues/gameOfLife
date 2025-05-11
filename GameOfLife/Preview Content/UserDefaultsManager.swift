//
//  UserDefaultsManager.swift
//  GameOfLife
//
//  Created by Praveen V on 11/05/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func setValue(value: Any?, for item: StoredUserDefaults) {
        UserDefaults.standard.set(value, forKey: item.rawValue)
    }
    
    func getValue(for item: StoredUserDefaults) -> Any? {
        UserDefaults.standard.value(forKey: item.rawValue)
    }
}
