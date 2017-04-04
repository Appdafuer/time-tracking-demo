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
    
    init?(fromDictionary dictionary: Any){        
        guard let service = dictionary as? [String:Any] else {return nil}
        guard let name = service ["name"] as? String else {return nil}
        guard let id = service ["id"] as? Int else {return nil}
        self.serviceName = name
        self.serviceID = id        
    }
}
