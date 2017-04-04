//
//  ServiceSelectionTableViewController.swift
//  TimeTracker
//
//  Created by Frederic Forster on 14/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ServiceSelectionTableViewController: UITableViewController {
    
    var allServices:[Service]?
    var delegate: ViewController!
    var project: Project!
    var index:Int!
    
    //MARK: Service Request
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: LoginLogicSingelton.sharedInstance.username!, password: LoginLogicSingelton.sharedInstance.password!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request("https://my.clockodo.com/api/services", headers: headers).responseJSON { response in
            
            if let JSON = response.result.value {
                self.allServices = []
                guard let casted = JSON as? [String:Any] else {return}
                guard let services = casted["services"] as? [Any] else {return}
                for service in services {
                    let castedService = (Service(fromDictionary: service)!)
                    self.allServices?.append(castedService)
                }
                
                self.tableView.reloadData()
            }
            
        }

    }
    
    //MARK: Navigation Bar
    func setNavBar(){
        self.navigationItem.title = "Services"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }
    
    func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TableView Settings 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let counter = allServices?.count {
            return counter
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Any", for: indexPath)
        cell.textLabel?.text = (self.allServices?[indexPath.row].serviceName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedService = allServices?[indexPath.row] {
            self.dismiss(animated: true, completion: nil)
            project.service = selectedService
            delegate.projectSelected(project: project, atIndex: index)
        }
    }
    
}
