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
    
    var edit: Bool?
    
    var journalEntry: JournalEntry?
    
    init?(coder: NSCoder, journalEntry: JournalEntry?, editBool: Bool) {
        super.init(coder: coder)
        self.journalEntry = journalEntry
        self.edit = editBool
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
    }

    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard segue.identifier == "saveUnwind" else { return }
         
         post = Post(postid: NetworkController.posts.count, numComments: 0, title: titleTextField.text!, body: bodyTextView.text, authorUserName: User.current!.userName, authorUserId: User.current!.userUUID.uuidString, userLiked: false, likes: 0, createdDate: Date().formatted(), comments: [])
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

}
