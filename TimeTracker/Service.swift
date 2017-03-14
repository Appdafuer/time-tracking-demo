//
//  Service.swift
//  TimeTracker
//
//  Created by Frederic Forster on 14/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class Service {
    var serviceName: String
    var serviceID: Int
    
    init(serviceName: String, serviceID: Int){
        self.serviceName = serviceName
        self.serviceID = serviceID
    }
}
