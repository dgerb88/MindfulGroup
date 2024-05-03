//
//  MeditationViewController.swift
//  mindfulness
//
//  Created by Dax Gerber on 4/17/24.
//

import UIKit

class MeditationViewController: UIViewController {

    let time = ["1 min", "2 min", "3 min", "4 min", "5 min", "6 min", "7 min", "8 min", "9 min", "10 min"]
    let environments = ["Forest", "Waves", "Rain", "Waterfall", "Trickling water", "Evil washing machine"]
    var selectedTimeValue = 1
    var selectedEnvironmentValue = "Forest"
    let gradientLayer = CAGradientLayer()
    
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var typePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.delegate = self
        timePicker.dataSource = self
        typePicker.delegate = self
        typePicker.dataSource = self
        // Do any additional setup after loading the view.
        
        setupGradientBackground()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MeditationSecondViewController
        destination.time = selectedTimeValue
        print(selectedEnvironmentValue)
        destination.environment = selectedEnvironmentValue
    }
    
}

extension MeditationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timePicker {
            return time.count
        } else {
            return environments.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == timePicker {
            selectedTimeValue = pickerView.selectedRow(inComponent: component) + 1
            return NSAttributedString(string: time[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            selectedEnvironmentValue = environments[row]
            return NSAttributedString(string: environments[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
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
