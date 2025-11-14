//
//  Config.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import Foundation

enum Config {
    static let baseURL = "http://localhost:5267"
    
    // API Endpoints
    static let loginEndpoint = "/api/Auth/login"
    static let registerEndpoint = "/api/Auth/register"
    static let profileEndpoint = "/api/Auth/profile"
    
    // Keychain identifiers
    static let keychainService = "Comp4977App"
    static let keychainAccount = "jwtToken"
}
