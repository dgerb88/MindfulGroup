//
//  JournalTableViewController.swift
//  mindfulness
//
//  Created by Andrew Higbee on 4/17/24.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    private let manager = EntryManager.shared
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return manager.allEntries().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = manager.allEntries()[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.date?.formatted(date: .complete, time: .complete)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    
    @IBSegueAction func addEditEntrySegue(_ coder: NSCoder, sender: Any?) -> AddEditEntryTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let entryToEdit = manager.allEntries()[indexPath.row]
            
            return AddEditEntryTableViewController(coder: coder, journalEntry: entryToEdit, editBool: true)
        } else {
            return AddEditEntryTableViewController(coder: coder)
        }
        
    }
    
    @IBAction func unwindToJournalTableView(segue: UIStoryboardSegue) {
//        guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? AddEditEntryTableViewController, var entry = sourceViewController.journalEntry else { return }
//        
//        if let selectedIndexPath = tableView.indexPathForSelectedRow {
//            EntryManager.shared.updateEntry(entry, title: entry.title ?? "", body: entry.body ?? "")
//        } else {
//            EntryManager.shared.createNewEntry(with: entry.title ?? "", with: entry.body ?? "")
//        }
    }
    
    
    
    /*
     if let cell = sender as? PostTableViewCell, let indexPath = tableView.indexPath(for: cell) {
         let postToEdit = NetworkController.posts[indexPath.row]
         
         return EditPostTableViewController(coder: coder, post: postToEdit)
     } else {
         return EditPostTableViewController(coder: coder)
     }
     */

    
    // MARK: - Navigation

    
    func getSearch() -> [JournalEntry] {
        let term = searchBar.text ?? ""
        var entries = manager.allEntries()
        
        let lowercasedTerm = term.lowercased()
        return entries.filter { entry in
            let titleMatch = entry.title!.lowercased().contains(lowercasedTerm)
            let bodyMatch = entry.body!.lowercased().contains(lowercasedTerm)
            return titleMatch || bodyMatch
        }
    }
    
}

extension JournalTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearch()
        searchBar.resignFirstResponder()
    }
}
