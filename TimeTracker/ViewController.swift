//
//  ViewController.swift
//  TimeTracker
//
//  Created by Frederic Forster on 09/03/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    var start: Date?
    var ticket:String = ""
    
    
    
    var timer:Timer?
    
    //var dictionary: [String:String] = ["a":"b", "d":"b"];
   
    var array: [String] = ["a", "a"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTouched(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        if title == "1" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectSelectionViewController") as! ProjectSelectionViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
           
        }else {
        
            if start == nil {
                startTimer(ticket: title)
            } else if start != nil && ticket == title {
                stopTimer()
            } else {
                doubleTimerAlert(fromButton: title)
            }
        }
    }
    
    func projectSelected(project: Project){
        print(project.description)
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
        label1.text = timeToString(time: Int(seconds))
    }
}

//1. button press -> starten, wenn ich wieder drücke, zeit ausgeben und evtl. neue starten
// immer wenn eine zeit gestoppt ist, mit print() ausgeben

