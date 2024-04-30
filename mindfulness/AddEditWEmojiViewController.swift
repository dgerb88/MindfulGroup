//
//  AddEditWEmojiViewController.swift
//  mindfulness
//
//  Created by Andrew Higbee on 4/29/24.
//

import UIKit

class AddEditWEmojiViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    var emoji: String?
    var journalEntry: JournalEntry?
    
    init?(coder: NSCoder, journalEntry: JournalEntry?) {
        super.init(coder: coder)
        self.journalEntry = journalEntry
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let journalEntry = self.journalEntry {
            titleTextField.text = journalEntry.title
            bodyTextView.text = journalEntry.body
            
            title = "Edit Post"
        } else {
            
            title = "Add Post"
        }
        if let emoji {
            titleTextField.text = "\(emoji) "
        }
        titleTextField!.layer.borderWidth = 1
        bodyTextView!.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        guard let titleTextField = titleTextField.text, let bodyTextView = bodyTextView.text else { return }
        
        if let journalEntry = self.journalEntry {
            EntryManager.shared.updateEntry(journalEntry, title: titleTextField, body: bodyTextView)
        } else {
            EntryManager.shared.createNewEntry(title: titleTextField, body: bodyTextView)
        }
    }
    
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    
    @IBAction func smileyTapped(_ sender: UIButton) {

        titleTextField.text = titleTextField.text! + "😀 "
    }
    
    @IBAction func concernedTapped(_ sender: UIButton) {

        titleTextField.text = titleTextField.text! + "🫤 "
    }
    
    
    @IBAction func neutralTapped(_ sender: UIButton) {

        titleTextField.text = titleTextField.text! + "😐 "
    }
    
    @IBAction func sleepyTapped(_ sender: UIButton) {

        titleTextField.text = titleTextField.text! + "😴 "
    }
    
    @IBAction func angryTapped(_ sender: UIButton) {

        titleTextField.text = titleTextField.text! + "🤬 "
    }
    
    @IBAction func sadTapped(_ sender: UIButton) {

        titleTextField.text = titleTextField.text! + "☹️ "
    }
    
    
    @IBAction func surprisedTapped(_ sender: UIButton) {

        titleTextField.text = titleTextField.text! + "😯 "
    }
    
    
}
