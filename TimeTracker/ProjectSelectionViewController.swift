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

class ProjectSelectionViewController: UITableViewController {

    var projects: [Project]?
    weak var delegate: ViewController?
    var index: Int!
    var isClock: Bool!

    // MARK: Customer Request
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        setNavBar()

        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: LoginLogicSingelton.sharedInstance.username!, password: LoginLogicSingelton.sharedInstance.password!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        Alamofire.request("https://my.clockodo.com/api/customers", headers: headers).responseJSON { response in

            if let JSON = response.result.value {
                self.projects = CustomersParser().getAllProjects(data: JSON)
                self.tableView.reloadData()
                LoadingViewGenerator.dismissView()
            }
        }

    }
    override func viewDidLoad() {
        LoadingViewGenerator.setView()
    }

    // MARK: Navigation Bar
    private func setNavBar() {
        self.navigationItem.title = "Projekte"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }

    func close() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: TableView Settings
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
            selectedProject.isClock = self.isClock
            LoadingViewGenerator.setView()
            // swiftlint:disable:next force_cast
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ServiceSelectionViewController") as! ServiceSelectionTableViewController
            vc.delegate = delegate
            vc.project = selectedProject
            vc.index = index
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
