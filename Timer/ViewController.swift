//
//  ViewController.swift
//  Timer
//
//  Created by viewQwest on 25/04/2018.
//  Copyright © 2018 sathyabaman. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var StartButton: UIButton!
    var timer = Timer()
    var hrs = 0
    var min = 0
    var sec = 0
    var milliSecs = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var diffMilliSecs = 0
    var isStarted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startStopBtnPressed(_ sender: UIButton) {
        isStarted = !isStarted
        
        if isStarted {
            self.resetContent()
            self.removeSavedDate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(ViewController.updateLabels(t:))), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
        
        isStarted ? StartButton.setTitle("Stop",for: .normal) : StartButton.setTitle("Start",for: .normal)
    }
    
    
    func resetContent() {
        self.removeSavedDate()
        timer.invalidate()
        self.TimerLabel.text = "00 : 00 : 00 : 00"
        self.milliSecs = 0
        self.sec = 0
        self.min = 0
        self.hrs = 0
    }
    
    @objc func updateLabels(t: Timer) {
        if(self.milliSecs == 10) {
            self.sec += 1
            self.milliSecs = 0
            if (self.sec == 60) {
                self.min += 1
                self.sec = 0
                if (self.min == 60) {
                    self.hrs += 1
                    self.min = 0
                }
            }
        } else { self.milliSecs += 1 }
        
        self.TimerLabel.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        self.hrs += hours
        self.min += mins
        self.sec += secs
        self.TimerLabel.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(ViewController.updateLabels(t:))), userInfo: nil, repeats: true)
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    // Selected for Lifecycle Methods
    @objc func pauseWhenBackground(noti: Notification) {
        self.timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
    }
    
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: savedDate)
            self.refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
            self.StartButton.setTitle("Stop",for: .normal)
            self.isStarted = true
        }
    }
    
   
    
  
}

