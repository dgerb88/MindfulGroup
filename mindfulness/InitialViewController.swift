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
        UIView.animate(withDuration: 0.5) {
            self.journalOutLet.alpha = 0
            self.Hstack.alpha = 1
            self.howAreYou.alpha = 1
        }
    }
    
    @IBOutlet weak var howAreYou: UILabel!
    @IBOutlet weak var journalOutLet: UIButton!
    @IBOutlet weak var Hstack: UIStackView!
    @IBOutlet weak var DaxButton: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIButton == DaxButton {
            let destination = segue.destination as! MeditationSecondViewController
            destination.time = 5
            destination.environment = environments.randomElement()
        }
    }
    
    

}
