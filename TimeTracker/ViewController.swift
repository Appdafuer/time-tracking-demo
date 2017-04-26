//
//  ViewController.swift
//  TimeTracker
//
//  Created by Frederic Forster on 09/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var projects: UICollectionView!

    var projectsArray: [Project?] =  []
    var selectedService: Service?

    var timer: Timer?

    private let saveRemoveKey = "SelectedProjects"

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        projects.dataSource = self
        projects.delegate = self

        TicketLoader.sharedInstance.loadTickets { (projects) in
            self.projectsArray = projects
            if self.getRunningProject() != nil {
                self.startTimer()
            }
            self.projects.reloadData()
            LoadingViewGenerator.dismissView()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        projects.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Navigation Bar
    private func setNavigationBar() {
        self.navigationItem.title = "Time tracking"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTicket))
    }

    func logout() {
        let alert = UIAlertController(title: "Logout", message: "Wollen sie sich wirklich ausloggen?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            if let runningProject = self.getRunningProject() {
                self.stopTimer(project: runningProject)
            }
            LoginLogicSingelton.sharedInstance.removeAuthorizationValues()
            self.removeDataFromUserDefaultsAndLocals()
            LoadingViewGenerator.dismissView()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in }))

        self.present(alert, animated: true, completion: nil)
    }

    func addTicket() {
        let alert = UIAlertController(title: "Select", message: "Wollen sie einen festen Zeiteintrag oder eine Uhr starten?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Uhr", style: .default, handler: {_ in
            self.initialzeSelcetionViewControllers(isClock: true)
        }))
        alert.addAction(UIAlertAction(title: "Eintrag", style: .default, handler: {_ in
            self.initialzeSelcetionViewControllers(isClock: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in }))
        self.present(alert, animated: true, completion: nil)
    }

    func initialzeSelcetionViewControllers(isClock: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // swiftlint:disable:next force_cast
        let profileNC = storyboard.instantiateViewController(withIdentifier: "ProjectNavController") as! UINavigationController
        // swiftlint:disable:next force_cast
        let vc = profileNC.topViewController as! ProjectSelectionViewController
        vc.delegate = self
        vc.index = projectsArray.count
        vc.isClock = isClock
        self.present(profileNC, animated: true, completion: nil)
    }

    func removeTicket(atIndex index: Int) {
        if projectsArray[index]?.clock != nil {
            stopTimer(project: projectsArray[index]!)
        }
        projectsArray.remove(at: index)
        projects.reloadData()
        saveDataInUserDefaults()
    }

    // MARK: UserDefaults
    private func saveDataInUserDefaults() {
        let us = UserDefaults.standard
        let serializer = ProjectsSerializer()
        us.set(serializer.serialize(projects: projectsArray), forKey: saveRemoveKey)

        us.synchronize()
    }

    private func removeDataFromUserDefaultsAndLocals() {
        let us = UserDefaults.standard
        us.removeObject(forKey: saveRemoveKey)
        projectsArray = []
    }

    // MARK: Project Settings
    func projectSelected(project: Project, atIndex index: Int) {
        if index == projectsArray.count {
            projectsArray.append(project)
        } else {
            projectsArray[index] = project
            self.saveDataInUserDefaults()
        }
        if project.entry == nil {
            setProjectDescription(index: index)
        }        
        projects.reloadData()
    }

    func setProjectDescription(index: Int) {
        AlertGenerator.showTextInputAlert(onViewController: self) { (newText) in
            if self.projectsArray[index]?.clock != nil {
                self.stopTimer(project: self.projectsArray[index]!)
                self.projectsArray[index]?.clock = nil
            }
            self.projectsArray[index]?.beschreibung = newText
            self.projects.reloadData()
            self.saveDataInUserDefaults()
            if (self.projectsArray[index]?.isClock)! {
                self.toggleTimer(forProject: self.projectsArray[index])
            } else {
                self.setEntry()
            }
        }
    }

    // MARK: Timer
    private func toggleTimer(forProject project: Project?) {
        if let project = project {
            if project.beschreibung == nil {
                label1.text = "Bitte Beschreibung eingeben"
            } else {
                if getRunningProject() != nil {
                    if project.clock != nil {
                        stopTimer(project: project)
                    } else {
                        doubleTimerAlert(project: project)
                    }
                } else {
                    startClock(project: project)
                }
            }
        } else {
            label1.text = "Bitte gültiges Ticket wählen."
        }
    }

    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerFired(_:)), userInfo: nil, repeats: true)
    }

    private func stopTimer(project: Project) {

        ClockLogic.sharedInstance.stopClock(project: project) { error in
            if error != nil {
                self.label1.text = "Could not stop Timer. Please try again"
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.label1.text = "Wählen sie ein Ticket."
                self.projects.reloadData()
            }

        }
    }

    // MARK: Fixed Entry
    private func setEntry() {

    }

    @objc func timerFired(_ timer: Timer) {
        guard let project = getRunningProject(),
        let clock = project.clock else {return}

        let seconds = Date().timeIntervalSince(clock.timeSince).rounded()
        label1.text = Utils.timeToString(time: Int(seconds)) + "\n " + project.customerName + " - " + project.projectName
    }

    // MARK: Get Running Project
    private func getRunningProject() -> Project? {
        for project in projectsArray where project?.clock != nil {
                return project
        }
        return nil
    }

    // MARK: Start Clock
    private func startClock(project: Project) {

        ClockLogic.sharedInstance.startClockOnline(project: project, serviceID: 117464) { error in
            if error != nil {
                self.label1.text = "Could not start Timer. Please try again"
            } else {
                self.startTimer()
                self.projects.reloadData()
            }
        }
    }

    // MARK: Double Timer Alert
    private func doubleTimerAlert(project: Project) {
        let alert = UIAlertController(title: "Active Tracker", message: "There is already an active tracker. Do you really want to start a new one?", preferredStyle: UIAlertControllerStyle.actionSheet)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel, handler: {_ in
            self.stopTimer(project: self.getRunningProject()!)
            self.startClock(project: project)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {_ in }))

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let project = projectsArray[indexPath.row]
        toggleTimer(forProject: project)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCell", for: indexPath) as! TicketCell
        cell.viewController = self
        cell.index = indexPath.row

        if let project = projectsArray[indexPath.row] {
            cell.lblKunde.text = ""
            cell.lblProject.text = ""
            cell.lblBeschreibung.text = ""
            cell.bBeschreibung.isHidden = false
            cell.project = projectsArray[indexPath.row]
            cell.contentView.backgroundColor = project.clock != nil ? Utils.appdafuer : UIColor.white
        }
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // swiftlint:disable:next force_cast
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let size = collectionView.frame.size
        let bottom = flowLayout.sectionInset.bottom
        let top = flowLayout.sectionInset.top
        let left = flowLayout.sectionInset.left
        let rigth = flowLayout.sectionInset.right

        var cellSize = flowLayout.itemSize
        cellSize.height = (size.height - bottom - top)/2 - 5
        cellSize.width = (size.width - left - rigth)/2 - 5

        return cellSize
    }
}
