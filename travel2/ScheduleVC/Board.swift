//
//  Board.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/25.
//

import Foundation

struct Schedule: Codable{
    var date: String // Date
    var schedule:[userSchedules]

    init(date: String = Date.getYYYYMMDD(date: .now), schedule:[userSchedules] = [userSchedules]()){
        self.date = date
        self.schedule = schedule
    }
}

struct userSchedules: Codable {
    var name: String
    var time: String // Date

    init(name: String = "", time: String = Date.getHHmm(date: Date(timeIntervalSince1970: -288000))) {
        self.name = name
        self.time = time
    }
}






