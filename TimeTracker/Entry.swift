//
//  Entry.swift
//  TimeTracker
//
//  Created by Frederic Forster on 26.04.17.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class Entry {

    let start: Date
    let end: Date

    init(forStartTime start: Date, andEndTime end: Date) {
        self.start = start
        self.end = end
    }
}
