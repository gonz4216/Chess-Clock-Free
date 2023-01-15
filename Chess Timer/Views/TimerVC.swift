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
 
    var timer: Timer = Timer()
    var count: Int = Int()
    var timerCounting = false
  
    
    
    
    
 
    @IBOutlet var pauseBtn: UIButton!
    @IBOutlet var topTap: UILabel!
    @IBOutlet var topTime: UILabel!
    
    
    @IBOutlet var greenTeamLabel: UILabel!
    @IBOutlet var blackTeamLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotate()
        
        
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
        if(timerCounting) {
            timerCounting = false
            timer.invalidate()
            pauseBtn.setImage(UIImage(named: "pause"), for: .normal)
          
        } else {
            timerCounting = true
            pauseBtn.setImage(UIImage(named: "play"), for: .normal)
          
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
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
        timer.invalidate()
        let alert = UIAlertController(title: "Restart Timer?", message: "Are you sure you would like to restart timer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            self.didResetDelegate?.didReset(resetMin: self.count)
            self.count = 0
            self.timer.invalidate()
            self.greenTeamLabel.text = self.makeTimeString(min: 0, seconds: 0)
            
            
             
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
}

extension TimerVC: SettingsVCDelegate {
    func didChangeMin(min: inout Int) {
        count = min * 60
        self.greenTeamLabel.text = self.makeTimeString(min: min, seconds: 0)
    }
    
   
    
     
    
    
}
