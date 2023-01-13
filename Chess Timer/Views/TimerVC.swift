//
//  ViewController.swift
//  Chess Timer
//
//  Created by Ethan Gonsalves on 2023-01-12.
//

import UIKit

class TimerVC: UIViewController {
    

   
 
    var timer: Timer = Timer()
    var count: Int = 0
    var timerCounting = false
  
    
    
 
    @IBOutlet var pauseBtn: UIButton!
    @IBOutlet var topTap: UILabel!
    @IBOutlet var topTime: UILabel!
    
    
    @IBOutlet var greenTeamLabel: UILabel!
    @IBOutlet var blackTeamLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotate()
        pauseBtn.setTitle("test", for: .normal)
      
    }
 
    private func rotate() {
        topTap.transform = CGAffineTransform(rotationAngle: .pi)
        topTime.transform = CGAffineTransform(rotationAngle: .pi)
    }
 
    @IBAction func PauseBtnTapped(_ sender: UIButton) {
        if(timerCounting) {
            timerCounting = false
            timer.invalidate()
            pauseBtn.setTitle("START", for: .normal)
        } else {
            timerCounting = true
            pauseBtn.setTitle("STOP", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
       
    }
    
    
    @objc func timerCounter() -> Void {
            count += 1
        let time = secondsToHoursMinSecs(seconds: count)
        let timeString = makeTimeString(min: time.0, seconds: time.1)
        greenTeamLabel.text = timeString
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
        
        let alert = UIAlertController(title: "Restart Timer?", message: "Are you sure you would like to restart timer", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in
            //do nothing
        }))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            self.count = 0
            self.timer.invalidate()
            self.greenTeamLabel.text = self.makeTimeString(min: 0, seconds: 0)
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
}

