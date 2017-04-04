//
//  ProjectsSerializer.swift
//  TimeTracker
//
//  Created by Frederic Forster on 29/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class ProjectsSerializer {

    // MARK: Serialize
    func serialize(projects: [Project?]) -> [Any] {
        var dictionaries = [Any]()
        for project in projects {
            let dictionary = project?.toDictionary()
            dictionaries.append(dictionary!)
        }
        return dictionaries
    }

    // MARK: Deserialize
    func deserialize(dictionaries: [Any]) -> [Project?] {
        var projects = [Project?]()
        for dictionary in dictionaries {
            let project = Project(fromDictionary: dictionary)
            projects.append(project)
        }
        return projects
    }
}
