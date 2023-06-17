//
//  PlaceData..swift
//  travel2
//
//  Created by WuShangJung on 2023/6/15.
//

import Foundation

struct TainanPlaces: Codable {
    let name: String
    let openTime: String?
    let district: String?
    let address: String
    let tel: String?
    let lat: Double?
    let long: Double?

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

struct allData {
    var touristSpots: [TainanPlaces]
    var hotels: [TainanPlaces]
    var restaurants: [TainanPlaces]
    var customPlaces: [TainanPlaces]
}
