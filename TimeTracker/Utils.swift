//
//  Utils.swift
//  TimeTracker
//
//  Created by Frederic Forster on 03/04/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit

class Utils {

    // MARK: Colors
    static let appdafuer = UIColor(red: 23.0 / 255.0, green: 204.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    static let white = UIColor.white
    static let black = UIColor.black
    static let clear = UIColor.clear

    // MARK: Date Formatter
    static func dateFromString(stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: stringDate)
        return date
    }

    static func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }

    // MARK: Int to time-String
    static func timeToString(time: Int) -> String {
        var tmp: Int = time

        let hours: Int = tmp/3600
        tmp = tmp%3600
        let min: Int = tmp/60
        tmp = tmp%60

        return String(format: "%02d:%02d:%02d", hours, min, tmp)
    }
}
