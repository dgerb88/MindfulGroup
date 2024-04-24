//
//  EntryManager.swift
//  mindfulness
//
//  Created by Andrew Higbee on 4/19/24.
//

import Foundation
import CoreData
import UIKit

class EntryManager {
    static let shared = EntryManager()
    
    private let context = PersistenceController.shared.viewContext
    
    
    // MARK: - Lists
    
    func createNewEntry(title: String, body: String) {
        let newEntry = JournalEntry(context: context)
        newEntry.id = UUID()
        newEntry.title = title
        newEntry.date = Date()
        newEntry.body = body
        saveContext()
    }
    
    func allEntries() -> [JournalEntry] {
        let fetchRequest = JournalEntry.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedEntries = try? context.fetch(fetchRequest)
        return fetchedEntries ?? []
    }
    
//    func deleteList(at indexPath: IndexPath) {
//        let entry = allEntries()[indexPath.row]
//        context.delete(entry)
//        saveContext()
//    }
    
    
    // MARK: - Items
    
    func delete(_ entry: JournalEntry) {
        let context = context
        context.delete(entry)
        saveContext()
    }
    
    func updateEntry(_ entry: JournalEntry, title: String, body: String) {

           let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

           entry.title = title
        entry.body = body

           do {
               try managedContext.save()
           } catch let error as NSError  {
               print("Could not save \(error), \(error.userInfo)")
           }
       }

    private func saveContext() {
        PersistenceController.shared.saveContext()
    }
    
}

