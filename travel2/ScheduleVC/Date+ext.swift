//
//  Date.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/6/4.
//

import Foundation

//extension Date {
//    static func getYYYYMMDD(date: Date) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMdd"
//        //let aDate = formatter.string(from: .init(timeIntervalSince1970: 0))
//        let timeStamp = 1685858616 // 2023/06/04
//        let timeInterval =  TimeInterval(timeStamp)
//        let aDate = formatter.string(from: .init(timeIntervalSince1970: timeInterval))
//        return formatter.date(from: aDate)!
//    }
//
//    static func getHHmm(date: Date) -> Date {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        let aTime = formatter.string(from: .init(timeIntervalSince1970: 1685858616))
//        return formatter.date(from: aTime)!
//    }
//}

extension Date {
    static func getYYYYMMDD(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: date)
    }

    static func getHHmm(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

}

