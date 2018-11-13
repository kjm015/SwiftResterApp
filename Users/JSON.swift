//
//  JSON.swift
//  Users
//
//  Created by Kurt McMahon on 10/10/18.
//  Copyright © 2018 Northern Illinois University. All rights reserved.
//

import Foundation

struct UserData: Decodable {
    let data: [User]
}

struct User: Codable {
    let firstName: String
    let lastName: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case avatar
    }
}

// Create structures to describe JSON responses

struct UserPostResponse: Decodable {
    let firstName: String
    let lastName: String
    let avatar: String
    
    let id: String
    let createdAt: String
}

struct UserGetResponse: Decodable {
    let id: Int
    
    let first_name: String
    let last_name: String
    let avatar: String
}

struct GetResponseData: Decodable {
    let data: UserGetResponse
}

