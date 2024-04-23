//
//  EntryManager.swift
//  mindfulness
//
//  Created by Andrew Higbee on 4/19/24.
//

import Foundation
import CoreData

class ItemManager {
    static let shared = ItemManager()
    
    private let context = PersistenceController.shared.viewContext
    
    
    // MARK: - Lists
    
    func createNewEntry(with title: String, with body: String) {
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
    
    func deleteList(at indexPath: IndexPath) {
        let entry = allEntries()[indexPath.row]
        context.delete(entry)
        saveContext()
    }
    
    
    // MARK: - Items
    
    func delete(_ entry: JournalEntry) {
        let context = context
        context.delete(entry)
        saveContext()
    }

    private func saveContext() {
        PersistenceController.shared.saveContext()
    }
    
}

