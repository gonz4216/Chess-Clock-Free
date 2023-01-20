//
//  SettingsVC.swift
//  Chess Timer
//
//  Created by Ethan Gonsalves on 2023-01-12.
//

import UIKit

protocol SettingsVCDelegate {
    func didChangeMin(min: inout Int)
}

class SettingsVC: UIViewController {

    var delegate: SettingsVCDelegate?
    
   
    @IBOutlet var MinuteLabel: UILabel!
  
    var minCount: Int = Int()
    
    
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
      
               
     }
    
    func plusCount() {
        minCount += 1
        return MinuteLabel.text = String("\(minCount) Minutes")

       
    }
    
    func minusCount() {
        if minCount < 1 {
            return
        }
       minCount -= 1
        return MinuteLabel.text = String("\(minCount) Minutes")

    }
    
    
    @IBAction func plusTimeTapped(_ sender: UIButton) {
        plusCount()
        delegate?.didChangeMin(min: &minCount)
        TimerVC().didResetDelegate = self
        func didReset(resetMin: Int) {
           minCount = resetMin
        }
        MinuteLabel.text = String("\(minCount) Minutes")

        
    }
    
  
    @IBAction func MinTimeTapped(_ sender: UIButton) {
        minusCount()
        
        MinuteLabel.text = String("\(minCount) Minutes")
      
    }
    
     
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
extension SettingsVC: TimerVCDelegate {
    func didReset(resetMin: Int) {
        
       minCount = 0
    }
    
    
}
