//
//  SessionService.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 20.10.2024.
//

import Foundation

protocol SessionServiceProtocol {
    func clearSession()
    func saveUserName(_ name: String)
    func getUserName() -> String?
}

class SessionService: SessionServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let sessionTokenKey = "sessionToken"
    private let userNameKey = "userName"
    
    func clearSession() {
        userDefaults.removeObject(forKey: "userName")
    }
    
    func saveUserName(_ name: String) {
        userDefaults.set(name, forKey: userNameKey)
    }
    
    func getUserName() -> String? {
        return userDefaults.string(forKey: userNameKey)
    }
}
