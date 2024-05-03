//
//  MeditationSecondViewController.swift
//  mindfulness
//
//  Created by Dax Gerber on 4/17/24.
//

import UIKit
import AVFoundation
import MediaPlayer

class MeditationSecondViewController: UIViewController {
    
    var time: Int?
    var environment: String?
    var progress: Float = 0
    var timeCount = 0
    var timer: Timer?
    let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), lineWidth: 15, rounded: false)
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.center = view.center
        setProgressViewColor(environment!)
        progressView.trackColor = .lightGray
        view.addSubview(progressView)
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
        
        
        progressView.progress = progress
        progressView.layer.opacity = 0.6
        timeLabel.layer.opacity = 0.7
        startProgressTimer()
    }
    
    func startProgressTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        playSound()
    }
    
    func stopProgressTimer() {
        timer?.invalidate()
        timer = nil
        audioPlayer?.stop()
        audioPlayer = nil
    }
    func playSound() {
        let pathToSound = Bundle.main.path(forResource: environment, ofType: "m4a")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setProgressViewColor(_ environment: String) {
        switch environment {
        case "Forest":
            progressView.progressColor = .forestGreen
        case "Evil washing machine":
            progressView.progressColor = .red
        case "Trickling water":
            progressView.progressColor = .forestGreen
        default:
            progressView.progressColor = .babyBlue
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopProgressTimer()
    }
    
    @objc func updateProgress() {
        timeCount += 1
        progress = Float(timeCount) / (Float(time!) * 60)
        progressView.progress = progress
        let countDown = (time! * 60) - timeCount
        let formatted = formatTimeCount(countDown)
        timeLabel.text = "\(formatted.0):\(formatted.1)"
        if progress >= 1.0 {
            stopProgressTimer()
        }
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func donePressed(_ sender: Any) {
        stopProgressTimer()
        dismiss(animated: true, completion: nil)
    }
    
    func formatTimeCount(_ time: Int) -> (String, String) {
        let minutes = String(time / 60)
        var seconds = String(time % 60)
        if Int(seconds)! < 10 {
            seconds = "0\(seconds)"
        }
        return (minutes, seconds)
    }
    
    
}

