//
//  DefaultsManager.swift
//  Mini2
//
//  Created by João Pedro Vieira Santos on 06/09/23.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String{
        case isFirstAccess
    }
    
    static func setFirstAccess(value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isFirstAccess.rawValue)
    }
    
    static func isFirstAccess() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.isFirstAccess.rawValue)
    }
}
