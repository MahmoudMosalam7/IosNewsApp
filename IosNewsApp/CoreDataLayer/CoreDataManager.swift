//
//  CoreDataManager.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 04/05/2026.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    private lazy var persistentContainer: NSPersistentContainer = {
        //Load coredata model to get all entities inside the model
        let container = NSPersistentContainer(name: "News")
        //Opens the database file
        //Creates it if it doesn't exist
        //Connects everything together
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    func save<T: NSManagedObject>(
        entityName: String,
        configure: @escaping (T) -> Void
    ) async -> Result<Bool, CoreDataError> {
        
        await context.perform {
            guard let entity = NSEntityDescription.insertNewObject(
                forEntityName: entityName,
                into: self.context
            ) as? T else {
                return .failure(.invalidData)
            }
            
            configure(entity)
            
            do {
                try self.context.save()
                return .success(true)
            } catch {
                return .failure(.saveFailed)
            }
        }
    }
}
