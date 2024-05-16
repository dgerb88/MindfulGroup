//
//  YogaInstructionViewController.swift
//  mindfulness
//
//  Created by Megan Schmoyer on 5/15/24.
//

import UIKit

class YogaInstructionViewController: UIViewController {
    @IBOutlet weak var yogaPoseImageView: UIImageView!
    
    @IBOutlet weak var yogaInstructionText: UILabel!
    @IBOutlet weak var yogaBreathingText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }
    

}
