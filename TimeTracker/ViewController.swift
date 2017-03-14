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
    
    var start: Date?
    var ticket:String = ""
    
    var selectedProjects:[Project?] =  [nil,nil,nil,nil]
    
    var timer:Timer?
    
    let persistratingUserContent = PersistratingUserContent()
    
    //var dictionary: [String:String] = ["a":"b", "d":"b"];
   
    var array: [String] = ["a", "a"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedProjects = persistratingUserContent.load()
        projects.reloadData()
        
        projects.dataSource = self
        projects.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        projects.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func projectSelected(project: Project, atIndex index:Int){
        selectedProjects[index] = project
        setProjectDescription(index: index)
        projects.reloadData()
    }
    
    func setProjectDescription(index:Int){
        _ = NewDescription(viewController: self) { (newText) in
            self.selectedProjects[index]?.beschreibung = newText
            self.projects.reloadData()
            self.persistratingUserContent.save(data: self.selectedProjects)
            self.initializeTimer(index: index)
            self.persistratingUserContent.load()
        }
    }
    
    func startTimer(ticket: String) {
        start = Date()
        self.ticket = ticket
        label1.text = "Timer " + ticket + " started at " + dateToString(date: start!)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerFired(_:)), userInfo: nil, repeats: true)
    }
   
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        let stop = Date()
        label1.text = "Timer " + ticket + " stopped at " + dateToString(date: stop)
        let time:TimeInterval = stop.timeIntervalSince(start!)
        print(String(format: "Stopped time: %.1f sec" , time))
        start = nil
        postTime(time: Int(time))
    }
    
    func postTime(time: Int){
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: "", password: "") {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        let parameters: Parameters = [
            "customers_id" : selectedProjects[Int(ticket)!]?.customerID ?? 123456,
            "services_id" : 117464,
            "billable" : 1,
            "duration" : time,
            "text" : selectedProjects[Int(ticket)!]?.description ?? ""
        ]
        
        Alamofire.request("https://my.clockodo.com/api/entries", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            if let JSON = response.result.value {
                print(JSON)
            }
        }
        
        label1.text = "Wählen sie ein Ticket."
    }
    
    func dateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func timeToString(time: Int) -> String {
        var tmp:Int = time
        
        let hours:Int = tmp/3600
        tmp = tmp%3600
        let min:Int = tmp/60
        tmp = tmp%60
        
        return String(format: "%02d:%02d:%02d", hours, min, tmp)
        
    }
    
    func doubleTimerAlert(fromButton button: String) {
        let alert = UIAlertController(title: "Active Tracker", message: "There is already an active tracker. Do you really want to start a new one?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel, handler: {action in
            self.stopTimer()
            self.startTimer(ticket: button)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {action in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func timerFired(_ timer:Timer) {
        let tmp:Date = Date()
        let seconds = tmp.timeIntervalSince(start!).rounded()
        label1.text = timeToString(time: Int(seconds)) + "\n" + (selectedProjects[Int(ticket)!]?.customerName)! + " - " + (selectedProjects[Int(ticket)!]?.projectName)!
    }
    
    func initializeTimer(index: Int){
        if selectedProjects[index] != nil {
            if selectedProjects[index]?.beschreibung == nil{
                label1.text = "Bitte Beschreibung eingeben"
            } else {
                if start == nil {
                    startTimer(ticket: String(index))
                } else if start != nil && ticket == String(index) {
                    stopTimer()
                } else {
                    doubleTimerAlert(fromButton: String(index))
                }
            }
        }else {
            label1.text = "Bitte gültiges Ticket wählen."
        }
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        initializeTimer(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        cell.viewController = self
        cell.index = indexPath.row
        cell.lblNumber.text = String(indexPath.row)
        if selectedProjects[indexPath.row] != nil {
            cell.bBeschreibung.isHidden = false
            cell.project = selectedProjects[indexPath.row]
        }else{
            cell.lblKunde.text = "Kunde"
            cell.lblProject.text = "Projekt"
            cell.lblBeschreibung.text = "Beschreibung"
            cell.bBeschreibung.isHidden = true
        }
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

//1. button press -> starten, wenn ich wieder drücke, zeit ausgeben und evtl. neue starten
// immer wenn eine zeit gestoppt ist, mit print() ausgeben

