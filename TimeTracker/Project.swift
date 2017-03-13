//
//  Projects.swift
//  TimeTracker
//
//  Created by Frederic Forster on 10/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation

class Project {
    
    var customerName: String
    var customerID: Int
    var projectName: String
    var projectID: Int
    
    init(customerName: String, customerID: Int, projectName: String, projectID: Int){
        self.customerName = customerName
        self.customerID = customerID
        self.projectName = projectName
        self.projectID = projectID
    }
    
    public var description: String {
        return "Customer Name: \(customerName) \nCustomer ID: \(customerID) \nProject Name: \(projectName) \nProject ID: \(projectID)"
    }
    
    
}
