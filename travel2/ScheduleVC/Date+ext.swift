//
//  Date.swift
//  travel2
//
//  Created by 吳宗祐 on 2023/6/4.
//

import Foundation
import UIKit

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

extension UIDatePicker {
    func customDatepicker(bgColor: UIColor, fontColor: UIColor){
    //datePicker的背景顏色
    self.backgroundColor = bgColor
    //設置datePicker的字體顏色
    self.setValue(fontColor, forKey: "textColor")
    //highlightsToday設為false，否則datePicker上的「今天」不會被改變字色self.setValue(false, forKey: "HighlightsToday")
    }
}

