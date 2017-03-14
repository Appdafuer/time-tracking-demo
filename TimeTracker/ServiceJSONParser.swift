//
//  ServiceJSONParser.swift
//  TimeTracker
//
//  Created by Frederic Forster on 14/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class ServiceJSONParser {
    
    private var Services: [Service] = []
    
    func parseServices(data: Any){
        
        guard let casted = data as? [String:Any] else {return}
        guard let services = casted["services"] as? [Any] else {return}
        for element in services {
            guard let service = element as? [String:Any] else {return}
            guard let name = service ["name"] as? String else {return}
            guard let id = service ["id"] as? Int else {return}
            Services.append(Service(serviceName: name, serviceID: id))
        }
        
    }
    
}
