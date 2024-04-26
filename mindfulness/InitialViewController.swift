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
    }
    
    
    @IBOutlet weak var DaxButton: UIButton!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIButton == DaxButton {
            let destination = segue.destination as! MeditationSecondViewController
            destination.time = 5
            destination.environment = environments.randomElement()
        }
    }
    
    

}
