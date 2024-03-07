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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
