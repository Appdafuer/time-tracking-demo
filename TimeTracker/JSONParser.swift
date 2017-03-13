//
//  JSONParser.swift
//  TimeTracker
//
//  Created by Frederic Forster on 10/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class JSONParser {
    
    private var Projects: [Project] = []
    
    init(data: Any){
        parseCustomers(data: data)
    }
    
    func parseCustomers(data: Any){
        
        guard let casted = data as? [String:Any] else {return}
        guard let customers = casted["customers"] as? [Any] else {return}
        for element in customers{
            guard let customer = element as? [String:Any] else {return}
            guard let active = customer["active"] as? Bool else {return}
            if active == true {
                guard let customerName = customer["name"] as? String else {return}
                guard let customerID = customer["id"] as? Int else {return}
                parseProjects(customer: customer, customerName: customerName, customerID: customerID)
            }
        }
        
    }
    
    func parseProjects(customer: [String:Any], customerName: String, customerID: Int){
        
        guard let projects = customer["projects"] as? [Any] else {return}
        for element in projects {
            guard let project = element as? [String:Any] else {return}
            guard let active = project["active"] as? Bool else {return}
            if active == true {
                guard let projectName = project["name"] as? String else {return}
                guard let projectID = project["id"] as? Int else {return}
                Projects.append(Project(customerName: customerName, customerID: customerID, projectName: projectName, projectID: projectID))
            }
        }
    }
    
    func getProjects() -> [Project]{
        return Projects
    }

    
}
