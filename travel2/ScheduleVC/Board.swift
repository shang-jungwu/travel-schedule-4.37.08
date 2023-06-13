//
//  Board.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/25.
//

import Foundation

struct Schedule: Codable{
    var date: String // Date
    var schedule:[userSchedule]

    init(date: String = Date.getYYYYMMDD(date: .now), schedule:[userSchedule] = [userSchedule]()){
        self.date = date
        self.schedule = schedule
    }
}

struct userSchedule: Codable {
    var name: String
    var time: String // Date

    init(name: String = "", time: String = Date.getHHmm(date: Date(timeIntervalSince1970: -288000))) {
        self.name = name
        self.time = time
    }
}






