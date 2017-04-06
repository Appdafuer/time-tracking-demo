//
//  LoginViewController.swift
//  TimeTracker
//
//  Created by Frederic Forster on 29/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NVActivityIndicatorView

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldUserID: UITextField!
    @IBOutlet weak var textFieldAPIKey: UITextField!
    @IBOutlet weak var btnLogin: UIButton!

    var holderView = HolderView(frame: CGRect.zero)

    // MARK: Actions
    @IBAction func textFieldUserIDChanged(_ sender: UITextField) {
        inputChanged(textField: sender)
    }

    @IBAction func textFieldAPIKeyChanged(_ sender: UITextField) {
        inputChanged(textField: sender)
    }

    @IBAction func loginPressed(_ sender: Any) {
        login()
    }

    // MARK: Start Settings
    override func viewDidAppear(_ animated: Bool) {
        textFieldUserID.becomeFirstResponder()
        textFieldUserID.text = ""
        textFieldAPIKey.text = ""
    }

    override func viewDidLoad() {
        textFieldUserID.delegate = self
        textFieldAPIKey.delegate = self
        self.navigationItem.title = "Login"

        let autValues = LoginLogicSingelton.sharedInstance.loadAuthorizationValues()
        if let autValues = autValues {
            LoadingViewGenerator.setView()
            LoginLogicSingelton.sharedInstance.testAuthorizationValues(userName: autValues.userName, apiKey: autValues.apiKey) { (valid) in
                if valid {
                    LoginLogicSingelton.sharedInstance.saveAuthorizationValues(userName: autValues.userName, apiKey: autValues.apiKey)
                    self.pushNextViewController()
                }
            }
        }
    }

    // MARK: Login
    private func login() {
        LoadingViewGenerator.setView()
        guard let userName = textFieldUserID.text else {return}
        guard let apiKey = textFieldAPIKey.text else {return}

        LoginLogicSingelton.sharedInstance.testAuthorizationValues(userName: userName, apiKey: apiKey) { (valid) in
            if valid {
                LoginLogicSingelton.sharedInstance.saveAuthorizationValues(userName: userName, apiKey: apiKey)
                self.pushNextViewController()
            } else {
                LoadingViewGenerator.dismissView()
                self.authorizationAlert()
            }
        }

    }

    private func pushNextViewController() {
        // swiftlint:disable:next force_cast
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: Failed Authorization
    private func authorizationAlert() {
        let alert = UIAlertController(title: "Failed Authorization", message: "Die Authorisierung ist fehlgeschlagen, bitte geben sie gültige Daten ein.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {_ in }))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: TextField Logic
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldAPIKey.text != "" && textFieldUserID.text != "" {
            textFieldUserID.resignFirstResponder()
            login()
        } else {
            if textField == textFieldUserID {
                textFieldAPIKey.becomeFirstResponder()
            } else {
                textFieldUserID.becomeFirstResponder()
            }
        }
        return true
    }

    private func inputChanged(textField: UITextField) {
        if textFieldAPIKey.text != "" && textFieldUserID.text != "" {
            textFieldUserID.returnKeyType = UIReturnKeyType.go
            textFieldAPIKey.returnKeyType = UIReturnKeyType.go
        } else {
            textFieldUserID.returnKeyType = UIReturnKeyType.default
            textFieldAPIKey.returnKeyType = UIReturnKeyType.default
        }
        textField.resignFirstResponder()
        textField.becomeFirstResponder()
    }

}
