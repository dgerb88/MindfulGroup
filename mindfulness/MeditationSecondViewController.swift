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
           
           if progress >= 1.0 {
               stopProgressTimer()
               dismiss(animated: true, completion: nil)
           }
       }
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
