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
    @IBOutlet var entireScreenView: UIView!
    
    var startAnimation: Bool = false
    var stopAnimation: Bool = false
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        otherInstructionLabelBackground.layer.opacity = 0.5
        otherInstructionLabelBackground.layer.cornerRadius = 10
        setupInitialShadowState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetAnimationState()
        startBreathingAnimation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
         // Stop animation when view is about to disappear
        stopBreathingAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        entireScreenView.layer.removeAllAnimations()
    }
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         gradientLayer.frame = view.bounds  // Ensure the gradient layer covers the full view
     }
     
    func setupGradientBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#983765")?.cgColor,  // Adjust the hex value as needed (including alpha as FF)
            UIColor(hex: "#3F0B27")?.cgColor,
            
        ].compactMap { $0 }  // Filters out any nil values if the hex was invalid
        gradientLayer.locations = [0.0, 1.0]  // Adjust this for different color stops
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)  // Insert the gradient layer at the very back
    }
    func setupInitialShadowState() {
        testImageView.layer.shadowOpacity = 1
        testImageView.layer.shadowRadius = 25
        testImageView.layer.shadowColor = UIColor.systemPink.cgColor
    }
    
    private func resetAnimationState() {
        testImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        instructionLabel.text = " "
    }
    
    func performBreathingAnimation() {
        if !stopAnimation {
            scaleUp()
        }
    }
    
    private func scaleUp() {
       
        if !stopAnimation {
            UIView.animate(withDuration: 6, animations: {
               
                self.testImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.instructionLabel.text = "Breath In"
                print("Breathin In")
            }) { _ in
                self.holdBreath()
            }
        }
    }
    
    private func holdBreath() {
        if !stopAnimation {
            UIView.animate(withDuration: 4, animations: {
                self.testImageView.layer.shadowOpacity = 1
                self.testImageView.layer.shadowRadius = 25
                self.testImageView.layer.shadowColor = UIColor.cyan.cgColor
                self.testImageView.transform = CGAffineTransform(scaleX: 1.49, y: 1.49)
                self.instructionLabel.text = "Hold"
                print("Holding")
            }) { _ in
                self.scaleDown()
                
            }
        }
    }
    
    private func scaleDown() {
        if !stopAnimation {
            UIView.animate(withDuration: 6, animations: {
               
                self.testImageView.transform = CGAffineTransform.identity
                self.testImageView.layer.shadowOpacity = 1
                self.testImageView.layer.shadowRadius = 25
                self.testImageView.layer.shadowColor = UIColor.cyan.cgColor
                self.instructionLabel.text = "Breath Out"
            }) { _ in
                if self.startAnimation {  // Check if we should repeat
                    self.performBreathingAnimation()
                }
            }
        }
    }
    
    // Call this method to start the animation
    func startBreathingAnimation() {
        startAnimation = true
        stopAnimation = false
        performBreathingAnimation()
    }
    
    // Call this method to stop the animation
    func stopBreathingAnimation() {
        stopAnimation = true
    }
}
//    func performBreathingAnimation() {
//           let breathInOutDuration: Double = 5
//           let holdDuration: Double = 6
//           let totalDuration: Double = (breathInOutDuration * 2) + holdDuration
//
//           UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: [.repeat, .allowUserInteraction], animations: {
//               // Breath In
//               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: breathInOutDuration / totalDuration) {
//                   self.testImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//                   self.testImageView.layer.shadowColor = UIColor.cyan.cgColor
//                   self.instructionLabel.text = "Breath In"
//               }
//               // Hold
//               UIView.addKeyframe(withRelativeStartTime: breathInOutDuration / totalDuration, relativeDuration: holdDuration / totalDuration) {
//                   self.instructionLabel.text = "Hold"
//               }
//               // Breath Out
//               UIView.addKeyframe(withRelativeStartTime: (breathInOutDuration + holdDuration) / totalDuration, relativeDuration: breathInOutDuration / totalDuration) {
//                   self.testImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                   self.instructionLabel.text = "Breath Out"
//               }
//           }, completion: { _ in
//
//           })
//       }
