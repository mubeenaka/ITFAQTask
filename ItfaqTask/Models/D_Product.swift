//
//  Products.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import Foundation

struct D_Product : Decodable {
    let id: Int
    let title : String
    let price : Float
    let category : String
    let description : String
    let image : String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case description = "description"
        case category = "category"
        case image = "image"
    }
}

