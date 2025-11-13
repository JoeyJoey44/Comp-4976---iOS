//
//  User.swift
//  Comp 4977 Assignment 2
//
//  Created by Andre Hindarmara on 2025-11-12.
//

import Foundation

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    // Backend uses CreatedAt / createdAt
    let createdAt: Date
    // Backend may return null for last login
    let lastLoginDate: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case createdAt
        case lastLoginDate
    }
}
