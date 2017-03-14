//
//  NewDescription.swift
//  TimeTracker
//
//  Created by Frederic Forster on 13/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit

class NewDescription {
    
    private var beschreibung: String = ""
    let viewController:UIViewController
    let completion:(String) -> ()
    
    init(viewController:UIViewController, completion:@escaping (String) -> ()){
        self.viewController = viewController
        self.completion = completion
        fireAlert()
    }
    
    func fireAlert() {
        let alert = UIAlertController(title: "Neue Beschreibung", message: "Geben sie eine neue Beschreibung ein:", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            let textField = alert.textFields![0]
            self.beschreibung = textField.text!
            self.completion(textField.text!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in}))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func getDescription() -> String {
        return beschreibung
    }
    
}
