//
//  Model.swift
//  APIManager
//
//  Created by Kamal on 17/09/19.
//  Copyright © 2019 Kamal. All rights reserved.
//

import Foundation

struct Welcome: Codable {
    let userID, id: Int
    let title, body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
    
    
}


struct Success<T: Codable>: Codable {
    let isError, flag: Int
    let result: T
    
    enum CodingKeys: String, CodingKey {
        case isError = "is_error"
        case flag, result
    }
}

// MARK: - Result
struct FAQ: Codable {
    let question, answer: String
}
