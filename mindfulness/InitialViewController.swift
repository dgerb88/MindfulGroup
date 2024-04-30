//
//  InitialViewController.swift
//  mindfulness
//
//  Created by Brayden Lemke on 2/28/24.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    let environments = ["Forest", "Waves", "Rain", "Waterfall", "Trickling water", "Evil washing machine"]
    
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
    
    

}
