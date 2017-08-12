//
//  DataController.swift
//  uscis
//
//  Created by Prasanna challa on 8/10/17.
//
//

import Foundation
import CoreData

struct DataController {
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CaseModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = DataController.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
