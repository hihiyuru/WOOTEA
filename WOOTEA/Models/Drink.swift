//
//  Drink.swift
//  WOOTEA
//
//  Created by 徐于茹 on 2023/8/31.
//

import Foundation

struct Order: Codable {
    let name: String
    let size: String
    let sugarLevel: String
    let iceLevel: String
    let toppingsOne: String
    let toppingsTwo: String
    let totalAmount: Double
    let count: Int
    let user: String
}

struct OrderPost: Codable {
    let fields: Order
}

struct OrderPostResponse: Codable {
    var id: String?
    var createdTime: String
    var fields: Order
}

struct Menu: Decodable {
    let categoryName: String
    let items: [Drink]
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "category_name"
        case items
    }
}

struct Drink: Decodable {
    let id: String
    let name: String
    let imageUrl: URL
    let isHasHot: Bool
    let price: Int
    let description: String
    let adjustableSweetness: Bool
    let adjustableTemperature: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case isHasHot = "is_has_hot"
        case price
        case description
        case adjustableSweetness = "adjustable_sweetness"
        case adjustableTemperature = "adjustable_temperature"
    }
}
