//
//  AuthResponse.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import Foundation

struct AuthResponse: Codable {
    let isSuccess: Bool
    let message: String
    let token: String?
    let user: User?
}

