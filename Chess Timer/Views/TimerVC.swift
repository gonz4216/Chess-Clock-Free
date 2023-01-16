//
//  ViewController.swift
//  Chess Timer
//
//  Created by Ethan Gonsalves on 2023-01-12.
//

import UIKit
protocol TimerVCDelegate {
    func didReset(resetMin: Int)
}
class TimerVC: UIViewController {
    

    var didResetDelegate: TimerVCDelegate?
 
    var topTeamTimer: Timer = Timer()
    var bottomTeamTimer: Timer = Timer()
    
    
    var count: Int = Int()
    var timerCounting = false
    var greenInPlay = false
    var darkInPlay = false
  
    
    
    
    
 
    @IBOutlet var pauseBtn: UIButton!
    @IBOutlet var topTap: UILabel!
    @IBOutlet var topTime: UILabel!
    
    
    @IBOutlet var greenTeamLabel: UILabel!
    @IBOutlet var blackTeamLabel: UILabel!
    
    @IBOutlet var topButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotate()
        print("WORKED")
 
    }
 
   //to do make another clock
    //redo process for the bottom team
    //get a clickable view that allows start and stop time
    
    @IBAction func darkTeamPlayTapped(_ sender: UIButton) {
    print("TAPPED")
        darkInPlay = true
        if !darkInPlay {
            topButton.isEnabled = false
            bottomTeamTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bottomTimerCounter), userInfo: nil, repeats: true)
           
           
           
        } else {
            topTeamTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            bottomButton.isEnabled = false
            return bottomTeamTimer.invalidate()
        }
        
       
     
        if count <= 0 {
            let nilPauses = UIAlertController(title: "No time set", message: "go to settings to add the time", preferredStyle: .alert)
            nilPauses.addAction(UIAlertAction(title: "No time", style: .default))
            self.present(nilPauses, animated: true)
            return
        }
        
        
             
        
         
    }
    
    @IBAction func greenTeamPlayTapped(_ sender: UIButton) {
         print("TAPPED")
        greenInPlay = true
        if !greenInPlay {
            bottomButton.isEnabled = false
            topTeamTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
           
           
        } else {
            bottomTeamTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bottomTimerCounter), userInfo: nil, repeats: true)
            topButton.isEnabled = false
            return topTeamTimer.invalidate()
        }
     
        
       greenInPlay = true
        if count <= 0 {
            let nilPauses = UIAlertController(title: "No time set", message: "go to settings to add the time", preferredStyle: .alert)
            nilPauses.addAction(UIAlertAction(title: "No time", style: .default))
            self.present(nilPauses, animated: true)
            return
        }
        
        if !timerCounting{
            
            topTeamTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            timerCounting = true
            return
        }
    }
    
    @IBAction func settingsBtnTapped(_ sender: UIButton) {
        let settingsVC =  self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC;
        self.present(settingsVC, animated: true)
        settingsVC.delegate = self
    }
    
    private func rotate() {
        topTap.transform = CGAffineTransform(rotationAngle: .pi)
        topTime.transform = CGAffineTransform(rotationAngle: .pi)
    }
 
    @IBAction func PauseBtnTapped(_ sender: UIButton) {
        if count <= 0 {
            let nilPauses = UIAlertController(title: "No time set", message: "go to settings to add the time", preferredStyle: .alert)
            nilPauses.addAction(UIAlertAction(title: "No time", style: .default))
            self.present(nilPauses, animated: true)
            return
        }
        if(greenInPlay || darkInPlay) {
            bottomTeamTimer.invalidate()
            topTeamTimer.invalidate()
            timerCounting = false
            darkInPlay = false
            greenInPlay = false
            pauseBtn.setImage(UIImage(named: "pause"), for: .normal)
          
        } else {
//            timerCounting = true
//            pauseBtn.setImage(UIImage(named: "pause"), for: .normal)
             
        }
        
       
       
    }
   
    
    @objc func timerCounter() -> Void {
        if count <= 0 {
            count = 1
        
        } else {
            count -= 1
        let time = secondsToHoursMinSecs(seconds: count)
        let timeString = makeTimeString(min: time.0, seconds: time.1)
        greenTeamLabel.text = timeString
        
        }
          
        
       
    }
    
    @objc func bottomTimerCounter() -> Void {
        if count <= 0 {
            count = 1
        
        } else {
            count -= 1
        let time = secondsToHoursMinSecs(seconds: count)
        let timeString = makeTimeString(min: time.0, seconds: time.1)
        blackTeamLabel.text = timeString
        
        }
          
        
       
    }
    
    func secondsToHoursMinSecs(seconds: Int) -> (Int, Int) {
        return (((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString( min: Int, seconds: Int) -> String {
        var timeString = ""
     
        timeString += String(format: "%02d", min)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    
    @IBAction func resetTapped(_ sender: UIButton) {
        topTeamTimer.invalidate()
        bottomTeamTimer.invalidate()
        let alert = UIAlertController(title: "Restart Timer?", message: "Are you sure you would like to restart timer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            self.didResetDelegate?.didReset(resetMin: self.count)
            self.count = 0
            self.topTeamTimer.invalidate()
            self.bottomTeamTimer.invalidate()
            self.greenTeamLabel.text = self.makeTimeString(min: 0, seconds: 0)
            self.blackTeamLabel.text = self.makeTimeString(min: 0, seconds: 0)
            
             
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
}

extension TimerVC: SettingsVCDelegate {
    func didChangeMin(min: inout Int) {
        count = min * 60
        self.greenTeamLabel.text = self.makeTimeString(min: min, seconds: 0)
        self.blackTeamLabel.text = self.makeTimeString(min: min, seconds: 0)
    }
    
   
    
     
    
    
}
