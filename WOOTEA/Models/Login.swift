//
//  Login.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/9/13.
//

import Foundation

struct User: Codable {
    var user: SignIn
}

struct SignIn: Codable {
    var login: String
    var email: String?
    var password: String
}

struct SignUpResponse: Codable {
    var userToken: String?
    var login: String?
    var errorCode: Int?
    var message: String?
    
    enum CodingKeys: String,CodingKey {
        case userToken = "User-Token"
        case login
        case errorCode = "error_code"
        case message
    }
}

struct SignInResponse: Codable {
    var userToken: String?
    var login: String?
    var email: String?
    var errorCode: Int?
    var message: String?
    
    enum CodingKeys: String,CodingKey {
        case userToken = "User-Token"
        case login
        case email
        case errorCode = "error_code"
        case message
    }
}
