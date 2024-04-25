//
//  AddEditEntryTableViewController.swift
//  mindfulness
//
//  Created by Andrew Higbee on 4/23/24.
//

import UIKit

class AddEditEntryTableViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
        
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
        
        tableView.reloadData()

        if let journalEntry = self.journalEntry {
            titleTextField.text = journalEntry.title
            bodyTextView.text = journalEntry.body
            
            title = "Edit Post"
        } else {
            
            title = "Add Post"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        guard let titleTextField = titleTextField.text, let bodyTextView = bodyTextView.text else { return }
        
        if let journalEntry = self.journalEntry {
            EntryManager.shared.updateEntry(journalEntry, title: titleTextField, body: bodyTextView)
        } else {
            EntryManager.shared.createNewEntry(title: titleTextField, body: bodyTextView)
        }
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    

}
