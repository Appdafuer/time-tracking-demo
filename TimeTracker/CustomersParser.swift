//
//  JSONParser.swift
//  TimeTracker
//
//  Created by Frederic Forster on 10/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class CustomersParser {

    // MARK: All active Projects from Clockodo
    func getAllProjects(data: Any) -> [Project] {
        var projects = [Project]()
        guard let casted = data as? [String:Any] else {return []}
        guard let customers = casted["customers"] as? [Any] else {return []}
        for element in customers {
            guard let customer = element as? [String:Any] else {return []}
            guard let active = customer["active"] as? Bool else {return []}
            if active == true {
                guard let customerName = customer["name"] as? String else {return []}
                guard let customerID = customer["id"] as? Int else {return []}
                let customerProjects = parseProjects(customer: customer, customerName: customerName, customerID: customerID)
                projects.append(contentsOf: customerProjects)
            }
        }
        return projects
    }

    private func parseProjects(customer: [String:Any], customerName: String, customerID: Int) -> [Project] {
        var projects = [Project]()
        guard let projectsDictionary = customer["projects"] as? [Any] else {return []}
        for element in projectsDictionary {
            guard let project = element as? [String:Any] else {return []}
            guard let active = project["active"] as? Bool else {return []}
            if active == true {
                guard let projectName = project["name"] as? String else {return []}
                guard let projectID = project["id"] as? Int else {return []}
                projects.append(Project(customerName: customerName, customerID: customerID, projectName: projectName, projectID: projectID))
            }
        }
        return projects
    }
}
