//
//  ProjectCell.swift
//  TimeTracker
//
//  Created by Frederic Forster on 13/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit

class TicketCell: UICollectionViewCell {

    @IBOutlet weak var bBeschreibung: UIButton!
    @IBOutlet weak var bTicket: UIButton!

    @IBOutlet weak var lblKunde: UILabel!
    @IBOutlet weak var lblProject: UILabel!
    @IBOutlet weak var lblBeschreibung: UILabel!

    var beschreibung: String = ""
    var viewController: ViewController?
    var index: Int!

    // MARK: Touch Actions
    @IBAction func beschreibungTouched(_ sender: Any) {
        viewController?.setProjectDescription(index: index)
    }

    @IBAction func ticketTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Löschen", message: "Wollen sie das Ticket wirklich löschen?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.viewController?.removeTicket(atIndex: self.index)
        }))
        self.viewController?.present(alert, animated: true, completion: nil)
    }

    // MARK: Settings
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }

    var project: Project? = nil {
        didSet {
            lblKunde.text = project?.customerName
            lblProject.text = project?.projectName
            lblBeschreibung.text = project?.beschreibung
        }
    }

}
