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
    

    @IBOutlet weak var imageViewForBreathing: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var instructionLabelBackground: UIView!
    @IBOutlet weak var otherInstructionLabelBackground: UIView!
    
    var startAnimation: Bool = false
    var stopAnimation: Bool = false
    let gradientLayer = CAGradientLayer()
    var startBreathInMonster = UIImage(named: "StartingBreathingMonster")
    var hold = UIImage(named: "BlueHoldMonster")
    var breathOutImage = UIImage(named: "BlueBreathOutMonster")
    var breathInImage = UIImage(named: "BlueBreathingMonster")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        
        otherInstructionLabelBackground.layer.cornerRadius = 10
        setupInitialShadowState()
        setupBlurForOtherInstructionLabelBackground()
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
        stopBreathingAnimation()
    }
    override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         gradientLayer.frame = view.bounds  // Ensure the gradient layer covers the full view
     }
    func setupBlurForOtherInstructionLabelBackground() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight) // Choose the appropriate style
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = otherInstructionLabelBackground.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Ensures the blur effect resizes with its parent view

        // Set the corner radius and enable clipping
        blurEffectView.layer.cornerRadius = 10 // Adjust this value to control the roundness of the corners
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.opacity = 0.4
        otherInstructionLabelBackground.addSubview(blurEffectView)
        otherInstructionLabelBackground.sendSubviewToBack(blurEffectView) // Sends the blur view behind any other content in otherInstructionLabelBackground
    }
    func setupGradientBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            
            UIColor(hex: "#8D331F")?.cgColor,  // Adjust the hex value as needed (including alpha as FF)
            UIColor(hex: "#983765")?.cgColor,
            
        ].compactMap { $0 }  // Ensure all color values are valid
        gradientLayer.locations = [0.0, 0.8, 1.0]  // Points at which the color changes occur
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)  // Middle top
        
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)  // Middle bottom
        view.layer.insertSublayer(gradientLayer, at: 0)  // Insert the gradient layer behind all other views
    }
    func setupInitialShadowState() {
        imageViewForBreathing.layer.shadowOpacity = 1
        imageViewForBreathing.layer.shadowRadius = 10
        imageViewForBreathing.layer.shadowColor = UIColor.systemPink.cgColor
    }
    
    private func resetAnimationState() {
        imageViewForBreathing.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        instructionLabel.text = " "
    }
    
    func performBreathingAnimation() {
        if !stopAnimation {
            scaleUp()
        }
    }
    
    @IBAction func doneBreathingPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    private func scaleUp() {
        imageViewForBreathing.image = breathInImage
        if !stopAnimation {
            UIView.animate(withDuration: 4, animations: {
               
                self.imageViewForBreathing.transform = CGAffineTransform(translationX: 0, y: -100)
                self.instructionLabel.text = "Breath In"
                print("Breathin In")
            }) { _ in
                self.holdBreath()
            }
        }
    }
    
    private func holdBreath() {
        imageViewForBreathing.image = hold
        if !stopAnimation {
            UIView.animate(withDuration: 7, animations: {
                self.imageViewForBreathing.layer.shadowOpacity = 1
                self.imageViewForBreathing.layer.shadowRadius = 10
                self.imageViewForBreathing.layer.shadowColor = UIColor(hex: "#A979DA")?.cgColor
                self.imageViewForBreathing.transform = CGAffineTransform(translationX: 0, y: -99)
                self.instructionLabel.text = "Hold"
                print("Holding")
            }) { _ in
                self.scaleDown()
                
            }
        }
    }
    
    private func scaleDown() {
        imageViewForBreathing.image = breathOutImage
        if !stopAnimation {
            UIView.animate(withDuration: 8, animations: {
               
                self.imageViewForBreathing.transform = CGAffineTransform.identity
                self.imageViewForBreathing.layer.shadowOpacity = 1
                self.imageViewForBreathing.layer.shadowRadius = 10
                self.imageViewForBreathing.layer.shadowColor = UIColor(hex: "#CFD7FF")?.cgColor
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

// OLD STUFF
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
