//
//  PlaceData..swift
//  travel2
//
//  Created by WuShangJung on 2023/6/15.
//

import Foundation

struct CulturalCenterAndRestaurant: Codable {
    //let id: Int
    let name: String
    //let summary: String
    //let introduction: String
    let openTime: String
    let district: String
    let address: String
    let tel: String
    let lat: Double? //緯度
    let long: Double? //經度

    enum CodingKeys: String, CodingKey {
        case name
        case openTime = "open_time"
        case district
        case address
        case tel
        case lat
        case long
    }
}

struct Hotel: Codable {
    //let id: String
    let name: String
    //let summary: String
    //let introduction: String
    let openTime: String
    let district: String
    let address: String
    let tel: String
    //let fax: String
    let lat: String // 其他檔案是存 Double
    let long: String // 其他檔案是存 Double


    enum CodingKeys: String, CodingKey {
        //case id
        case name
       // case summary
        //case introduction
        case openTime = "open_time"
        case district
        case address
        case tel
        //case fax
        case lat
        case long
    }
}

