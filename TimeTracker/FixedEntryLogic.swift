//
//  FixedEntryLogic.swift
//  TimeTracker
//
//  Created by Frederic Forster on 26.04.17.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import Alamofire

class FixedEntryLogic {

    static let sharedInstance = FixedEntryLogic()

    private init() {}

    func sendEntry(project: Project, completion: @escaping (_ error: Error?) -> Void) {

        var headers: HTTPHeaders = [:]

        if let authorizationHeader = Request.authorizationHeader(user: LoginLogicSingelton.sharedInstance.username!, password: LoginLogicSingelton.sharedInstance.password!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        let parameters: Parameters = [
            "customers_id": project.customerID,
            "projects_id": project.projectID,
            "services_id": project.service.serviceID,
            "billable": 1,
            "text": project.beschreibung ?? "",
            "time_since": Utils.dateToString(date: (project.entry?.start)!),
            "time_until": Utils.dateToString(date: (project.entry?.end)!)
        ]

        Alamofire.request("https://my.clockodo.com/api/entries", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            if let _ = response.result.value {
                completion(nil)
            } else {
                completion(TimeTrackerError(title: "Eintrag konnte nicht gesetzt werden"))
            }

        }

    }

}
