//
//  ClockLogic.swift
//  TimeTracker
//
//  Created by Frederic Forster on 04/04/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import Alamofire

class ClockLogic {

    static let sharedInstance = ClockLogic()

    private init() {}

    // MARK: Start Clock
    func startClockOnline(project: Project, serviceID: Int, completion: @escaping (_ error: Error?) -> Void) {

        var headers: HTTPHeaders = [:]

        if let authorizationHeader = Request.authorizationHeader(user: LoginLogicSingelton.sharedInstance.username!, password: LoginLogicSingelton.sharedInstance.password!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        let parameters: Parameters = [
            "customers_id": project.customerID,
            "projects_id": project.projectID,
            "services_id": project.service.serviceID,
            "billable": 1,
            "text": project.beschreibung ?? ""
        ]

        Alamofire.request("https://my.clockodo.com/api/clock", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            if let JSON = response.result.value,
                let clock = Clock(data: JSON) {
                project.clock = clock
                completion(nil)
            } else {
                completion(TimeTrackerError(title: "Could not start Clock"))
            }
        }
    }

    // MARK: Stop Clock
    func stopClock(project: Project, completion: @escaping (_ error: Error?) -> Void) {

        guard let clock = project.clock else {
            completion(TimeTrackerError(title: "Can not stop clock on not running project"))
            return
        }

        var headers: HTTPHeaders = [:]

        if let authorizationHeader = Request.authorizationHeader(user: LoginLogicSingelton.sharedInstance.username!, password: LoginLogicSingelton.sharedInstance.password!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        Alamofire.request("https://my.clockodo.com/api/clock/\(clock.clockID)", method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            if let error = response.result.error {
                completion(error)
            } else {
                project.clock = nil
                completion(nil)
            }
        }

    }
}
