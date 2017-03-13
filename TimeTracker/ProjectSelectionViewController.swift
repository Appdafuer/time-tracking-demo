//
//  ProjectSelectionViewController.swift
//  TimeTracker
//
//  Created by Frederic Forster on 10/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ProjectSelectionViewController : UITableViewController {
    
    var projects: [Project]?
    var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: "frederic@appdafuer.com", password: "ezft7noum5jh2ml3hni8coortmynv2u5") {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request("https://my.clockodo.com/api/customers", headers: headers).responseJSON { response in
            
            if let JSON = response.result.value {
                
                self.projects = JSONParser(data: JSON).getProjects()
                self.tableView.reloadData()
                
            }
        }

        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let counter = projects?.count {
            return counter
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Any", for: indexPath)
        cell.textLabel?.text = (self.projects?[indexPath.row].customerName)! + " - " + (self.projects?[indexPath.row].projectName)!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedProject = projects?[indexPath.row] {
            delegate?.projectSelected(project: selectedProject)
            self.dismiss(animated: true, completion: nil)
        }        
    }
    
    
    
    
}
