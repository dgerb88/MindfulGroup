//
//  ViewController.swift
//  mindfulness
//
//  Created by Brayden Lemke on 2/27/24.
//

import UIKit

class BreathViewController: UIViewController {
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        circleView.layer.cornerRadius = 12
        circleView.layer.opacity = 0.5
        
        let originalRed = CGFloat(177.0/255.0)
        let originalGreen = CGFloat(210.0/255.0)
        let originalBlue = CGFloat(219.0/255.0)
        
        circleView.backgroundColor = UIColor(red: originalRed, green: originalGreen, blue: originalBlue, alpha: 1)
        
        let breathInOutDuration: Double = 5
        let delayDuration: Double = 6
        let totalDuration: Double = breathInOutDuration + delayDuration + breathInOutDuration
        
        let breathInOutRelativeDuration = breathInOutDuration / totalDuration
        let firstStartRelativeTime: Double = 0
        let secondStartRelativeTime = (breathInOutDuration + delayDuration) / totalDuration
        
        UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.repeat, .allowUserInteraction]) {
            UIView.addKeyframe(withRelativeStartTime: firstStartRelativeTime, relativeDuration: breathInOutRelativeDuration) {
                self.circleView.transform = CGAffineTransform(scaleX: 5, y: 5)
                self.circleView.layer.opacity = 1
            }
            UIView.addKeyframe(withRelativeStartTime: breathInOutRelativeDuration, relativeDuration: delayDuration / totalDuration) {
                let red = CGFloat(0.0/255.0)
                let green = CGFloat(109.0/255.0)
                let blue = CGFloat(176.0/255.0)
                
                self.circleView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            }
            UIView.addKeyframe(withRelativeStartTime: secondStartRelativeTime, relativeDuration: breathInOutRelativeDuration) {
                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.circleView.layer.opacity = 0.5
                self.circleView.backgroundColor = UIColor(red: originalRed, green: originalGreen, blue: originalBlue, alpha: 1)
            }
        }
        
        Task {
            do {
                while true {
                    instructionLabel.text = "Breath In"
                    try await Task.sleep(nanoseconds: UInt64(5000000000))
                    instructionLabel.text = "Hold"
                    try await Task.sleep(nanoseconds: UInt64(5000000000))
                    instructionLabel.text = "Breath Out"
                    try await Task.sleep(nanoseconds: UInt64(5000000000))
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    


}

