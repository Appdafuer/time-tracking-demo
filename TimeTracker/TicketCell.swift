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
    @IBOutlet weak var lblNumber: UILabel!

    var beschreibung: String = ""
    var viewController: ViewController?
    var index: Int!

    // MARK: Touch Actions
    @IBAction func beschreibungTouched(_ sender: Any) {
        viewController?.setProjectDescription(index: index)
    }

    @IBAction func ticketTouched(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next force_cast
        let profileNC = storyboard.instantiateViewController(withIdentifier: "ProjectNavController") as! UINavigationController
        // swiftlint:disable:next force_cast
        let vc = profileNC.topViewController as! ProjectSelectionViewController
        vc.delegate = viewController
        vc.index = index
        viewController?.present(profileNC, animated: true, completion: nil)
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
