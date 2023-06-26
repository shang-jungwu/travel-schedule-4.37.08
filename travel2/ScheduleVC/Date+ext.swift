//
//  Date.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/6/4.
//

import Foundation
import UIKit


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


