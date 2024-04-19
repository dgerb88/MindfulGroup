//
//  ViewController.swift
//  mindfulness
//
//  Created by Dax on 4/15/24.
//  Made a branch
//  Megan made a branch
//  Andrew made a branch

import UIKit

class BreathViewController: UIViewController {
    
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var instructionLabelBackground: UIView!
    
    @IBOutlet weak var otherInstructionLabelBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        otherInstructionLabelBackground.layer.opacity = 0.5
        otherInstructionLabelBackground.layer.cornerRadius = 10
        
        let originalRed = CGFloat(177.0/255.0)
        let originalGreen = CGFloat(210.0/255.0)
        let originalBlue = CGFloat(219.0/255.0)
        
        
        let breathInOutDuration: Double = 5
        let delayDuration: Double = 6
        let totalDuration: Double = breathInOutDuration + delayDuration + breathInOutDuration
        
        let breathInOutRelativeDuration = breathInOutDuration / totalDuration
        let firstStartRelativeTime: Double = 0
        let secondStartRelativeTime = (breathInOutDuration + delayDuration) / totalDuration
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(5))
            
            await UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.repeat, .allowUserInteraction]) {
                UIView.addKeyframe(withRelativeStartTime: firstStartRelativeTime, relativeDuration: breathInOutRelativeDuration) {
                    self.testImageView.transform = CGAffineTransform(scaleX: 5, y: 5)
                    self.testImageView.layer.opacity = 1
                }
                UIView.addKeyframe(withRelativeStartTime: breathInOutRelativeDuration, relativeDuration: delayDuration / totalDuration) {
                    let red = CGFloat(0.0/255.0)
                    let green = CGFloat(109.0/255.0)
                    let blue = CGFloat(176.0/255.0)
                    
                }
                UIView.addKeyframe(withRelativeStartTime: secondStartRelativeTime, relativeDuration: breathInOutRelativeDuration) {
                    self.testImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.testImageView.layer.opacity = 0.5
                    
                }
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

