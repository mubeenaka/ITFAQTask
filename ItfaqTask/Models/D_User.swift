//
//  D_User.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import Foundation

struct D_User : Decodable {
    let id: Int
    let username : String
    let password : String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case password = "password"
    }
}
