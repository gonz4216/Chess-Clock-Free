//
//  ViewController.swift
//  Chess Timer
//
//  Created by Ethan Gonsalves on 2023-01-12.
//
// TODO: When a player hits 0 reset the timer
// TODO: Make alert too
import UIKit
protocol TimerVCDelegate {
    func didReset(resetMin: Int)
}
class TimerVC: UIViewController {
    
    
    var didResetDelegate: TimerVCDelegate?
    
    weak  var topTeamTimer: Timer?
    weak  var bottomTeamTimer: Timer?
    
    
    var topCount: Int = Int()
    var botCount: Int = Int()
    var timerCounting = false
    var topCounting: Bool = false
    var bottomCounting: Bool = false
    
    
    
    
    
    
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
        timerFinished()
       
        bottomCounting = false
        topCounting = false
        
      
    }
    
     
    
    //TODO:   Refactor code && Redo style(Color of font when active and now active, add close button in settings vc and dismis the vc when clicked + add onboarding in the future and make redo github repo,
    
     //MARK: - - TIME TAPPED
    @IBAction func bottomTeamTapped(_ sender: UIButton) {
   
        bottomTeamTimer?.invalidate()
        bottomCounting = false
        topCounting = true
        
        if !bottomCounting {
            topTeamTimer?.invalidate()
        
            topTeamTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TopTimerCounter), userInfo: nil, repeats: true)
        } else {
            bottomTeamTimer?.invalidate()
           

        }
       
            
        
       
        noTimeAlert()
    }
   
    
    @IBAction func topTeamTapped(_ sender: UIButton) {
  
        topTeamTimer?.invalidate()
    bottomCounting = true
    topCounting = false
        if !topCounting {
            bottomTeamTimer?.invalidate()
            bottomTeamTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bottomTimerCounter), userInfo: nil, repeats: true)
        } else {
            topTeamTimer?.invalidate()
        }
        noTimeAlert()
  
 
 

    }
    
    //MARK: --^^  TIME TAPPED ^^

    
    @IBAction func settingsBtnTapped(_ sender: UIButton) {
        topTeamTimer?.invalidate()
        bottomTeamTimer?.invalidate()
        let settingsVC =  self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC;
        self.present(settingsVC, animated: true)
        settingsVC.delegate = self
    }
    
    private func rotate() {
        topTap.transform = CGAffineTransform(rotationAngle: .pi)
        topTime.transform = CGAffineTransform(rotationAngle: .pi)
    }
    
    @IBAction func PauseBtnTapped(_ sender: UIButton) {
        if topCount <= 0 && botCount <= 0 {
            let nilPauses = UIAlertController(title: "No time set", message: "go to settings to add the time", preferredStyle: .alert)
            nilPauses.addAction(UIAlertAction(title: "No time", style: .default))
            self.present(nilPauses, animated: true)
            return
        }
         
        
        if(topCounting || bottomCounting) {
            bottomTeamTimer?.invalidate()
            topTeamTimer?.invalidate()
            timerCounting = false
            bottomCounting = false
            topCounting = false
            pauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            
        }
        
        
    }
    
    
    @objc func TopTimerCounter() -> Void {
        if topCount <= 0 {
            topTeamTimer?.invalidate()
            botCount = 0
            blackTeamLabel.text = makeBottomTimeString(min: 0, seconds: 0)
            print("n\(botCount) bot")
        } else {
            topCount -= 1
            let time = secondsToHoursMinSecs(seconds: topCount)
            let timeString = makeTimeString(min: time.0, seconds: time.1)
            greenTeamLabel.text = timeString
            
        }
        print(topCount)
      
        
        
    }
    
    @objc func bottomTimerCounter() -> Void {
        if botCount <= 0 {
            bottomTeamTimer?.invalidate()
            botCount = 0
            greenTeamLabel.text = makeBottomTimeString(min: 0, seconds: 0)
            
        } else {
            botCount -= 1
            let time = secondsToHoursMinSecs(seconds: botCount)
            let botTimeString = makeBottomTimeString(min: time.0, seconds: time.1)
            blackTeamLabel.text = botTimeString
            
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
    func makeBottomTimeString( min: Int, seconds: Int) -> String {
        var botTimeString = ""
        
        botTimeString += String(format: "%02d", min)
        botTimeString += " : "
        botTimeString += String(format: "%02d", seconds)
        
        return botTimeString
    }
    
    
    @IBAction func resetTapped(_ sender: UIButton) {
        topTeamTimer?.invalidate()
        bottomTeamTimer?.invalidate()
        topCount = 0
        botCount = 0
        let alert = UIAlertController(title: "Restart Timer?", message: "Are you sure you would like to restart timer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            //MARK: to do
            self.didResetDelegate?.didReset(resetMin: self.topCount)
            self.didResetDelegate?.didReset(resetMin: self.botCount)
            self.topCount = 0
            self.botCount = 0
            self.topTeamTimer?.invalidate()
            self.bottomTeamTimer?.invalidate()
            self.greenTeamLabel.text = self.makeTimeString(min: 0, seconds: 0)
            self.blackTeamLabel.text = self.makeBottomTimeString(min: 0, seconds: 0)
            
            
            
        }))
        
        self.present(alert, animated: true)
    }
    
    func timerFinished() {
        if topCount == 0 || botCount == 0{
            didResetDelegate?.didReset(resetMin: self.topCount)
            didResetDelegate?.didReset(resetMin: self.botCount)
            topCount = 0
            botCount = 0
            topTeamTimer?.invalidate()
            bottomTeamTimer?.invalidate()
            greenTeamLabel.text = self.makeTimeString(min: 0, seconds: 0)
            blackTeamLabel.text = self.makeBottomTimeString(min: 0, seconds: 0)
             
        }
         
        
    }
    
    
    
}

extension TimerVC: SettingsVCDelegate {
    func didChangeMin(min: inout Int) {
        topCount = min * 60
        botCount = min * 60
        self.greenTeamLabel.text = self.makeTimeString(min: min, seconds: 0)
        self.blackTeamLabel.text = self.makeBottomTimeString(min: min, seconds: 0)
    }
    
    
    
    
    
    
}


extension TimerVC {
    func noTimeAlert() {
        if topCount <= 0 && botCount <= 0 {
            
            let nilPauses = UIAlertController(title: "No time set", message: "go to settings to add the time", preferredStyle: .alert)
            nilPauses.addAction(UIAlertAction(title: "No time", style: .default))
            self.present(nilPauses, animated: true)
            topTeamTimer?.invalidate()
            bottomTeamTimer?.invalidate()
           
        }
    }
    
}

                        

