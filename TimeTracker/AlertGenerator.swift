//
//  AlertGenerator.swift
//  TimeTracker
//
//  Created by Frederic Forster on 13/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit

class AlertGenerator {

    // MARK: Show Alert 
    static func showTextInputAlert(onViewController viewController: UIViewController, completion:@escaping (String) -> Void) {
        let alert = UIAlertController(title: "Neue Beschreibung", message: "Geben sie eine neue Beschreibung ein:", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            let textField = alert.textFields![0]
                completion(textField.text!)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in}))

        viewController.present(alert, animated: true, completion: nil)
    }
}
