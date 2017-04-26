//
//  EntryDetailViewController.swift
//  TimeTracker
//
//  Created by Frederic Forster on 26.04.17.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var lblKunde: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var txtFieldBeschreibung: UITextField!
    @IBOutlet weak var datePickerVon: UIDatePicker!
    @IBOutlet weak var datePickerBis: UIDatePicker!
    @IBOutlet weak var btnSenden: UIButton!

    var project: Project!
    weak var delegate: ViewController!
    var index: Int!

    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
        lblKunde.text = project.customerName + " - " + project.projectName
        lblService.text = project.service.serviceName
    }

    // MARK: Navigation Bar
    func setNavBar() {
        self.navigationItem.title = "Entry"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }

    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func sendEntry(_ sender: Any) {
        let startDate = datePickerVon.date
        let endDate = datePickerBis.date

        if txtFieldBeschreibung.text == "" {
            launchNoDescriptionAlert()
        } else if endDate < startDate {
            launchImpossibleDatesAlert()
        } else {
            LoadingViewGenerator.setView()
            project.entry = Entry(forStartTime: startDate, andEndTime: endDate)
            project.beschreibung = txtFieldBeschreibung.text
            FixedEntryLogic.sharedInstance.sendEntry(project: project, completion: { error in
                if error != nil {
                    LoadingViewGenerator.dismissView()
                    self.launchCouldNotSendEntry()
                } else {
                    LoadingViewGenerator.dismissView()
                    self.dismiss(animated: true, completion: nil)
                    self.delegate.projectSelected(project: self.project, atIndex: self.index)
                }

            })
        }
    }

    func launchNoDescriptionAlert() {
        let alert = UIAlertController(title: "Keine Beschreibung", message: "Bitte geben sie eine Beschreibung an.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in }))
        self.present(alert, animated: true, completion: nil)
    }

    func launchImpossibleDatesAlert() {
        let alert = UIAlertController(title: "Falsche Zeiten", message: "Die Endzeit kann nicht vor der Startzeit liegen", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in}))
        self.present(alert, animated: true, completion: nil)
    }

    func launchCouldNotSendEntry() {
        let alert = UIAlertController(title: "Error", message: "Entrag konnte nicht gesendet werden, bitte erneut versuchen.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in}))
        self.present(alert, animated: true, completion: nil)
    }
}
