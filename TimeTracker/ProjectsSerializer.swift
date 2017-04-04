//
//  ProjectsToJSON.swift
//  TimeTracker
//
//  Created by Frederic Forster on 29/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class ProjectsToJSON {
    
    func serialize(projects: [Project?]) -> [Any]{
        var project = [String:Any]()
        var projectArray = [Any]()
        
        for element in projects {
            project["customerName"] = element?.customerName
            project["customerID"] = element?.customerID
            project["name"] = element?.projectName
            project["id"] = element?.projectID
            project["description"] = element?.beschreibung
            
            projectArray.append(project)
        }
        return projectArray
    }
    
    func deserialize(savedArray: [Any]) -> [Project?]{
        var projects = [Project?]()
        for element in savedArray {
            if let project = element as? [String:Any],
             let customerName = project["customerName"] as? String,
             let customerID = project["customerID"] as? Int,
             let projectName = project["name"] as? String,
             let projectID = project["id"] as? Int,
             let description = project["description"] as? String {
                let tmpProject = Project(customerName: customerName, customerID: customerID, projectName: projectName, projectID: projectID)
                tmpProject.beschreibung = description
                projects.append(tmpProject)
            } else {
                projects.append(nil)
            }
            
        }
        return projects
    }
}
