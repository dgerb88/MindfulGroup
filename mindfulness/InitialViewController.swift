//
//  InitialViewController.swift
//  mindfulness
//
//  Created by Brayden Lemke on 2/28/24.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            if let quote = try? await QuoteController.getQuote() {
                quoteLabel.text = "\(quote.q)\n-\(quote.a)"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MeditationSecondViewController
        destination.time = 5
        destination.environment = "Waves"
    }
    

}
