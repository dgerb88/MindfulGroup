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
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var congratulationsLabel: UILabel!
    
    var time: Int?
    var environment: String?
    var progress: Float = 0
    var timeCount = 0
    var timer: Timer?
    var progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), lineWidth: 15, rounded: false)
    var audioPlayer: AVAudioPlayer?
    var hasStarted = false
    var didFinishMeditation = false
    var startTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.center = view.center
        setProgressViewColor(environment ?? "Forest")
        progressView.trackColor = .lightGray
        view.addSubview(progressView)
        timeLabel.text = String("\(time ?? 0):00")
        timeLabel.layer.cornerRadius = 15
        timeLabel.layer.masksToBounds = true
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        startTime = time ?? 0
        
        // Set the image
        imageView.image = UIImage(named: environment ?? "Evil washing machine")
        
        // Set content mode to scale aspect fill
        if environment == "Pokemon" {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
        // Add the image view to the view hierarchy
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        progressView.progress = progress
        startProgressTimer()
    }
    
    func startProgressTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        playSound()
        hasStarted = true
        
        UIView.animate(withDuration: 0.3) {
            self.progressView.alpha = 0.6
            self.timeLabel.alpha = 0.6
            self.congratulationsLabel.alpha = 0
        }
        if environment == "Pokemon" {
            progressView.alpha = 0
            timeLabel.alpha = 0
            congratulationsLabel.alpha = 0
            playPauseButton.alpha = 0
        }
        
    }
    
    func stopProgressTimer() {
        timer?.invalidate()
        timer = nil
        audioPlayer?.setVolume(0, fadeDuration: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.audioPlayer?.stop()
            self.audioPlayer = nil
        }
        hasStarted = false
    }
    
    func pauseProgressTimer() {
        timer?.invalidate()
        timer = nil
        audioPlayer?.setVolume(0, fadeDuration: 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.audioPlayer?.pause()
        }
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
        progress = Float(timeCount) / (Float(time ?? 1) * 60)
        progressView.progress = progress
        let countDown = (time! * 60) - timeCount
        let formatted = formatTimeCount(countDown)
        timeLabel.text = "\(formatted.0):\(formatted.1)"
        if progress >= 1.0 {
            UIView.animate(withDuration: 0.3) {
                self.progressView.alpha = 0
                self.timeLabel.alpha = 0
                self.congratulationsLabel.alpha = 0.6
                self.congratulationsLabel.layer.cornerRadius = 15
                self.congratulationsLabel.layer.masksToBounds = true
            }
            let systemSoundId: SystemSoundID = 1111
            AudioServicesPlaySystemSound(systemSoundId)
            stopProgressTimer()
            didFinishMeditation = true
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timeCount = 0
            progress = 0
            time = startTime
            progressView.progress = progress
            setProgressViewColor(environment!)
        }
    }
    
    
    @IBAction func pauseTimeButton(_ sender: Any) {
        if didFinishMeditation {
            startProgressTimer()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            didFinishMeditation = false
        } else {
            if hasStarted {
                //Pause timer
                playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                pauseProgressTimer()
                hasStarted.toggle()
                print("pause please")
            } else {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
                audioPlayer?.setVolume(1, fadeDuration: 1)
                audioPlayer?.play()
                playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                hasStarted.toggle()
                print("start again")
            }
        }
    }
    
    
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

