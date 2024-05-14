//
//  JournalTableViewController.swift
//  mindfulness
//
//  Created by Andrew Higbee on 4/17/24.
//

import UIKit
import CoreData

class JournalTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private let manager = EntryManager.shared
    
    private var fetchedResultsController: NSFetchedResultsController<JournalEntry>!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        
        let fetchRequest: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

                fetchedResultsController = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: manager.context,
                    sectionNameKeyPath: nil,
                    cacheName: nil
                )
                fetchedResultsController.delegate = self

                do {
                    try fetchedResultsController.performFetch()
                } catch {
                    print("Error fetching entries: \(error)")
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
        
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithTransparentBackground()
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
            let entry = fetchedResultsController.object(at: indexPath)
            cell.textLabel?.text = entry.title
            cell.detailTextLabel?.text = entry.date?.formatted(date: .complete, time: .complete)
            return cell
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            allEntries.remove(at: indexPath.row)
//            filteredEntries.remove(at: indexPath.row)
            let entry = fetchedResultsController.object(at: indexPath)
            manager.delete(entry)
//            tableView.reloadData()
        }
    }
    
    @IBSegueAction func addEditEntrySegue(_ coder: NSCoder, sender: Any?) -> AddEditWEmojiViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }

        let entryToEdit = fetchedResultsController.object(at: indexPath)

        return AddEditWEmojiViewController(coder: coder, journalEntry: entryToEdit)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            fatalError("Unhandled case")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    @IBAction func unwindToJournalTableView(segue: UIStoryboardSegue) {
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
        let backgroundView = UIView()
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)  // Insert the gradient layer behind all other views
        tableView.backgroundView = backgroundView
    }

}

extension JournalTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            let predicate: NSPredicate?
            if searchText.isEmpty {
                predicate = nil
            } else {
                predicate = NSPredicate(format: "title CONTAINS[c] %@ OR body CONTAINS[c] %@", searchText, searchText)
            }
            fetchedResultsController.fetchRequest.predicate = predicate
            do {
                try fetchedResultsController.performFetch()
            } catch {
                print("Error fetching entries: \(error)")
            }
            tableView.reloadData()
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
}
