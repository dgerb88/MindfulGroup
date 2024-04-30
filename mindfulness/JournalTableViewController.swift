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
    
    var allEntries: [JournalEntry] = []
    var filteredEntries: [JournalEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        filteredEntries = manager.allEntries()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredEntries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = filteredEntries[indexPath.row]
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.date?.formatted(date: .complete, time: .complete)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

    
//    @IBSegueAction func editEntrySegue(_ coder: NSCoder, sender: Any?) -> AddEditEntryTableViewController? {
//        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
//
//        let entryToEdit = filteredEntries[indexPath.row]
//
//        return AddEditEntryTableViewController(coder: coder, journalEntry: entryToEdit)
//    }
    
    
    @IBSegueAction func addEditEntrySegue(_ coder: NSCoder, sender: Any?) -> AddEditWEmojiViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }

        let entryToEdit = filteredEntries[indexPath.row]

        return AddEditWEmojiViewController(coder: coder, journalEntry: entryToEdit)
    }
    
    
    @IBAction func unwindToJournalTableView(segue: UIStoryboardSegue) {
        filteredEntries = manager.allEntries()
        tableView.reloadData()
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

    
        func getSearch() {
            if !searchBar.text!.isEmpty {
                let searchText = searchBar.text
                filteredEntries = manager.allEntries().filter { entry in
                    let titleMatch = entry.title!.lowercased().contains(searchText!.lowercased())
                    let bodyMatch = entry.body!.lowercased().contains(searchText!.lowercased())
                    return titleMatch || bodyMatch
                }
                tableView.reloadData()
            } else {
                filteredEntries = manager.allEntries()
                tableView.reloadData()
            }
        }
}

extension JournalTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearch()
        searchBar.resignFirstResponder()
    }
}
