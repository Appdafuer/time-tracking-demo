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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: "frederic@appdafuer.com", password: "ezft7noum5jh2ml3hni8coortmynv2u5") {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request("https://my.clockodo.com/api/customers", headers: headers).responseJSON { response in
            
            if let JSON = response.result.value {
                
            }
            
        }

    }
    
}
