//
//  InitialViewController.swift
//  mindfulness
//
//  Created by Brayden Lemke on 2/28/24.
//

import UIKit
import UserNotifications

class InitialViewController: UIViewController {
    
    @IBOutlet weak var quoteLabelBackground: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    let environments = ["Forest", "Waves", "Rain", "Waterfall", "Trickling water", "Pokemon"]
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            if let quote = try? await QuoteController.getQuote() {
                quoteLabel.text = "\(quote.q)\n\n-\(quote.a)"
            }
        }
        journalOutLet.alpha = 1
        Hstack.alpha = 0
        howAreYou.alpha = 0
        checkForPermission()
        blurForQuoteBackground()
        setupGradientBackground()
    }
    
    @IBAction func quickJournalButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.journalOutLet.alpha = 0
            self.Hstack.alpha = 1
            self.howAreYou.alpha = 1
        }
    }
    
    @IBOutlet weak var howAreYou: UILabel!
    @IBOutlet weak var journalOutLet: UIButton!
    @IBOutlet weak var Hstack: UIStackView!
    @IBOutlet weak var DaxButton: UIButton!
    
    @IBOutlet weak var PokemonButton: UIButton!
    @IBOutlet weak var meganButton: UIButton!
    
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var surprisedButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    @IBOutlet weak var sleepyButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var concernedButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIButton == DaxButton {
            let destination = segue.destination as! MeditationSecondViewController
            destination.time = 5
            destination.environment = environments.randomElement()
        } else if sender as? UIButton == meganButton {
            //Do nothing
        } else if sender as? UIButton == PokemonButton {
            let destination = segue.destination as! MeditationSecondViewController
            destination.time = 2
            destination.environment = environments.last!
        } else {
            let button = sender as? UIButton
            let destinationNavigationController = segue.destination as! UINavigationController
            let destination = destinationNavigationController.topViewController as! AddEditWEmojiViewController
            destination.emoji = button?.titleLabel?.text
        }
        UIView.animate(withDuration: 0.5, delay: 1) {
            self.journalOutLet.alpha = 1
            self.Hstack.alpha = 0
            self.howAreYou.alpha = 0
        }
    }
    
    func checkForPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.dispatchNotification()
                    }
                }
            case .denied:
                return
            case .authorized:
                self.dispatchNotification()
            default:
                return
            }
        }
    }
    
    func dispatchNotification() {
        let id = "dailyReminder"
        let title = "Meditation"
        let body = "A daily meditation can give you the reset you need"
        let hour = 17
        let minute = 0
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calendar = Calendar.current
        var dateComponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
        notificationCenter.add(request)
    }
    func blurForQuoteBackground() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight) // Choose the appropriate style
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = quoteLabelBackground.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Ensures the blur effect resizes with its parent view

        // Set the corner radius and enable clipping
        blurEffectView.layer.cornerRadius = 10 // Adjust this value to control the roundness of the corners
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.opacity = 0.4
            quoteLabelBackground.addSubview(blurEffectView)
        quoteLabelBackground.sendSubviewToBack(blurEffectView) // Sends the blur view behind any other content in otherInstructionLabelBackground
    }
    func setupGradientBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(hex: "#8F549D")?.cgColor,
            UIColor(hex: "983765")?.cgColor,
            UIColor(hex: "#8D331F")?.cgColor,
            
        ].compactMap { $0 }  // Ensure all color values are valid
        gradientLayer.locations = [0.0, 0.8, 1.0]  // Points at which the color changes occur
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)  // Middle top
        
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)  // Middle bottom
        view.layer.insertSublayer(gradientLayer, at: 0)  // Insert the gradient layer behind all other views
    }

}
