//
//  Clock.swift
//  TimeTracker
//
//  Created by Frederic Forster on 03/04/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class Clock {
    
    let id: Int
    let timeSince: Date
    
    init?(data: Any){
        guard let clock = data as? [String:Any],
        let params = clock["running"] as? [String:Any],
        let id = params["id"] as? Int,
        let timeSinceString = params["time_since"] as? String,
        let timeSince = Utils.dateFromString(stringDate: timeSinceString)
        else {return nil}
        self.id = id
        self.timeSince = timeSince
    }
}
