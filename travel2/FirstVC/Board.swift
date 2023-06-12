//
//  Board.swift
//  travel2
//
//  Created by WuShangJung on 2023/5/25.
//

import Foundation

struct Board: Codable{
    var names: [String]
}

struct Monster: Codable {
    var name: String
    var time: String // Date

    init(name: String = "", time: String = Date.getHHmm(date: .now)) {
        self.name = name
        self.time = time
    }
}

struct Schedule: Codable{
    var date: String//Date
    var schedule:[Monster]

    init(date: String = Date.getYYYYMMDD(date: .now), schedule:[Monster] = [Monster]()){
        self.date = date
        self.schedule = schedule
    }

}


