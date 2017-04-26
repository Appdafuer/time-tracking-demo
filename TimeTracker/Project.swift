//
//  Projects.swift
//  TimeTracker
//
//  Created by Frederic Forster on 10/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class Project {

    private let customerNameKey = "customerName"
    private let customerIDKey = "customerID"
    private let projectNameKey = "name"
    private let projectIDKey = "id"
    private let descriptionKey = "description"
    private let serviceNameKey = "serviceName"
    private let serviceIDKey = "serviceID"

    let customerName: String
    let customerID: Int
    let projectName: String
    let projectID: Int
    var beschreibung: String?
    var isClock: Bool?
    var clock: Clock?
    var entry: Entry?
    var service: Service

    // MARK: Initializer
    init(customerName: String, customerID: Int, projectName: String, projectID: Int) {
        self.customerName = customerName
        self.customerID = customerID
        self.projectName = projectName
        self.projectID = projectID
        self.service = Service(serviceName: "Programmierung", serviceID: 117464)
    }

    init?(fromDictionary dictionary: Any) {
        if let project = dictionary as? [String:Any],
            let customerName = project[customerNameKey] as? String,
            let customerID = project[customerIDKey] as? Int,
            let projectName = project[projectNameKey] as? String,
            let projectID = project[projectIDKey] as? Int,
            let serviceName = project[serviceNameKey] as? String,
            let serviceID = project[serviceIDKey] as? Int {
            self.customerName = customerName
            self.customerID = customerID
            self.projectName = projectName
            self.projectID = projectID
            self.beschreibung = project[descriptionKey] as? String
            self.service = Service(serviceName: serviceName, serviceID: serviceID)
        } else {
            return nil
        }
    }

    // MARK: Dictionary
    func toDictionary() -> [String:Any] {
        var project = [String: Any]()
        project[customerNameKey] = self.customerName
        project[customerIDKey] = self.customerID
        project[projectNameKey] = self.projectName
        project[projectIDKey] = self.projectID
        project[descriptionKey] = self.beschreibung
        project[serviceNameKey] = self.service.serviceName
        project[serviceIDKey] = self.service.serviceID
        return project
    }

    // MARK: toString()
    public var description: String {
        return "Customer Name: \(customerName) \nCustomer ID: \(customerID) \nProject Name: \(projectName) \nProject ID: \(projectID)"
    }

}
