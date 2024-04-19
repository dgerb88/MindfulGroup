//
//  MeditationSecondViewController.swift
//  mindfulness
//
//  Created by Dax Gerber on 4/17/24.
//

import UIKit

class MeditationSecondViewController: UIViewController {
    
    var time: Int?
    var environment: String?
    var progress: Float = 0
    var timeCount = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = String("\(time!):00")
        timeLabel.layer.cornerRadius = 15
        timeLabel.layer.masksToBounds = true
        let imageView = UIImageView(frame: UIScreen.main.bounds)
                
                // Set the image
                imageView.image = UIImage(named: environment ?? "Evil washing machine")
                
                // Set content mode to scale aspect fill
                imageView.contentMode = .scaleAspectFill
                // Add the image view to the view hierarchy
                self.view.addSubview(imageView)
                self.view.sendSubviewToBack(imageView)
        
        
        progressView.setProgress(progress, animated: true)
        startProgressTimer()
    }
    
    func startProgressTimer() {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func stopProgressTimer() {
           timer?.invalidate()
           timer = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopProgressTimer()
    }
    
    @objc func updateProgress() {
        timeCount += 1
        progress = Float(timeCount) / (Float(time!) * 60)
        progressView.setProgress(progress, animated: true)
        let countDown = (time! * 60) - timeCount
        let formatted = formatTimeCount(countDown)
        timeLabel.text = "\(formatted.0):\(formatted.1)"
        if progress >= 1.0 {
            stopProgressTimer()
        }
    }
    
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func donePressed(_ sender: Any) {
        stopProgressTimer()
        dismiss(animated: true, completion: nil)
    }
    
    func formatTimeCount(_ time: Int) -> (String, String) {
        var minutes = String(time / 60)
        var seconds = String(time % 60)
        if Int(seconds)! < 10 {
            seconds = "0\(seconds)"
        }
        return (minutes, seconds)
    }
    
    
}
