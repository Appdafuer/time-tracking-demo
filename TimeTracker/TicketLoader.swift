//
//  TicketLoader.swift
//  TimeTracker
//
//  Created by Frederic Forster on 03/04/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import Alamofire

class TicketLoader {

    static let sharedInstance = TicketLoader()

    private init() {}

    func loadTickets(completion: @escaping (_ projects: [Project?]) -> Void) {
        let projects = loadDataFromUserDefaults()

        lookForUnclosedProjects { runningProject in
            if let runningProject = runningProject {
                let combinedProjects = self.combine(projects: projects, withRunningProject: runningProject)
                completion(combinedProjects)
            } else {
                completion(projects)
            }
        }
    }

    // MARK: User Defaults
    private func loadDataFromUserDefaults() -> [Project?] {
        let us = UserDefaults.standard
        let deserializer = ProjectsSerializer()
        guard let tmpProjects = us.object(forKey: "SelectedProjects") as? [Any] else {return []}
        let projects = deserializer.deserialize(dictionaries: tmpProjects)

        return projects
    }

    // MARK: Look for running online Projects
    private func lookForUnclosedProjects(completion: @escaping (_ runningProject: Project?) -> Void) {
        var headers: HTTPHeaders = [:]

        if let authorizationHeader = Request.authorizationHeader(user: LoginLogicSingelton.sharedInstance.username!, password: LoginLogicSingelton.sharedInstance.password!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        Alamofire.request("https://my.clockodo.com/api/clock", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            if let JSON = response.result.value,
                let clock = Clock(data: JSON),
                let dictionary = JSON as? [String:Any],
                let params = dictionary["running"] as? [String:Any],
                let customerID = params["customers_id"] as? Int,
                let projectID = params["projects_id"] as? Int,
                let description = params["text"] as? String {

                self.getProjectFrom(customerID: customerID, projectID: projectID, description: description) { project in
                    if let project = project {
                        project.clock = clock
                        completion(project)
                    } else {
                        let unknownProject = Project(customerName: "unknown", customerID: customerID, projectName: "unknown", projectID: projectID)
                        unknownProject.beschreibung = description
                        unknownProject.clock = clock
                        completion(unknownProject)
                    }
                }
            } else {
                completion(nil)
            }
        }

    }

    // MARK: Compare existing Projects with running Project
    private func combine(projects: [Project?], withRunningProject runningProject: Project) -> [Project?] {
        var found = false
        for project in projects {
            if let project = project,
            project.customerID == runningProject.customerID,
            project.projectID == runningProject.projectID,
            project.beschreibung == runningProject.beschreibung {
                project.clock = runningProject.clock
                found = true
            }

        }
        var result = projects
        if !found {
            result.insert(runningProject, at: 0)
        }

        return result
    }

    // MARK: Get Project Data for ID's
    private func getProjectFrom(customerID: Int, projectID: Int, description: String, completion: @escaping (Project?) -> Void) {
        //First load all project Data, then create a new Ticket for the given Project

        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: LoginLogicSingelton.sharedInstance.username!, password: LoginLogicSingelton.sharedInstance.password!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        Alamofire.request("https://my.clockodo.com/api/customers", headers: headers).responseJSON { response in

            var newProject: Project? = nil

            if let JSON = response.result.value {
                let activeProjects = CustomersParser().getAllProjects(data: JSON)

                for project in activeProjects where project.customerID == customerID && project.projectID == projectID {
                        newProject = Project(customerName: project.customerName, customerID: customerID, projectName: project.projectName, projectID: projectID)
                        newProject?.beschreibung = description
                }
            }

            completion(newProject)
        }
    }
}
