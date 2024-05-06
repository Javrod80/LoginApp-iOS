//
//  SessionManager.swift
//  LoginApp
//
//  Created by Mañanas on 19/4/24.
//

import Foundation

 
import Foundation

class SessionManager {
    static let shared = SessionManager()
        
    
    private let userDefaults = UserDefaults.standard
    private let usernameKey = "username"
    private let passwordKey = "password"
    
    var isLoggedIn: Bool {
        return getUsername() != nil && getPassword() != nil
    }
    
    func saveCredentials(username: String, password: String) {
        userDefaults.set(username, forKey: usernameKey)
        userDefaults.set(password, forKey: passwordKey)
    }
    
    func getUsername() -> String? {
        return userDefaults.string(forKey: usernameKey)
    }
    
    func getPassword() -> String? {
        return userDefaults.string(forKey: passwordKey)
    }
    
    func clearCredentials() {
        userDefaults.removeObject(forKey: usernameKey)
        userDefaults.removeObject(forKey: passwordKey)
    }
}
