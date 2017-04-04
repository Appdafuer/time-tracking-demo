//
//  LoginLogicSingelton.swift
//  TimeTracker
//
//  Created by Frederic Forster on 29/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import Alamofire

class LoginLogicSingelton {

    static let sharedInstance = LoginLogicSingelton()

    var username: String?
    var password: String?

    private let usernameKey = "UserName"
    private let apiKeyKey = "API-Key"

    private init() {}

    // MARK: Test Values
    func testAuthorizationValues(userName: String, apiKey: String, completion: @escaping (Bool) -> Void) {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: userName, password: apiKey) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }

        Alamofire.request("https://my.clockodo.com/api/services", headers: headers).responseJSON { response in

            if let JSON = response.result.value {
                let valid = self.isAuthorizationSucceeded(data: JSON)
                completion(valid)
            } else {
                completion(false)
            }
        }

    }

    func isAuthorizationSucceeded(data: Any) -> Bool {
        guard let casted = data as? [String:Any] else {return false}
        if casted["error"] != nil {
        return false
        } else {return true}
    }

    // MARK: Save Values
    func saveAuthorizationValues(userName: String, apiKey: String) {
        let us = UserDefaults.standard
        us.set(userName, forKey: usernameKey)
        us.set(apiKey, forKey: apiKeyKey)
        username = userName
        password = apiKey
        us.synchronize()
    }

    // MARK: Load Values
    func loadAuthorizationValues() -> (userName: String, apiKey: String)? {
        let us = UserDefaults.standard
        guard let userName = us.object(forKey: usernameKey) as? String else {return nil}
        guard let apiKey = us.object(forKey: apiKeyKey) as? String else {return nil}
        username = userName
        password = apiKey
        return (userName, apiKey)
    }

    // MARK: Remove Values
    func removeAuthorizationValues() {
        let us = UserDefaults.standard
        us.removeObject(forKey: usernameKey)
        us.removeObject(forKey: apiKeyKey)
    }

}
