//
//  Board.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/25.
//

import Foundation

struct Schedule: Codable{
    var date: String 
    var schedule:[userSchedule]

    init(date: String = Date.getYYYYMMDD(date: .now), schedule:[userSchedule] = [userSchedule]()){
        self.date = date
        self.schedule = schedule
    }
}

struct userSchedule: Codable {
    var placeName: TainanPlaces
    var time: String

    init(placeName: TainanPlaces = TainanPlaces(name: "", openTime: nil, district: nil, address: "", tel: nil, lat: nil, long: nil), time: String = Date.getHHmm(date: Date(timeIntervalSince1970: -288000))) {
        self.placeName = placeName
        self.time = time
    }
}





