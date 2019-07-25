//
//  DataManager.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 23/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
    private let mainContext:NSManagedObjectContext
    init(context:NSManagedObjectContext) {
        self.mainContext = context
    }
    
    
    
    func getFolders() -> [Folder] {
        return getEntities(Folder.self)
    }
    
    func createNewFolder(name:String) {
        let folderEntity = Folder(context: mainContext)
    
        folderEntity.name = name
        folderEntity.creationDate = Date()
        saveContext(mainContext)
    }
    
    

    
    
    
    //MARK: - Private Methods
    
    private func getEntities<EntityClass:NSManagedObject>(_ entityClass:EntityClass.Type) -> [EntityClass] {
    
        let fetchRequest = entityClass.fetchRequest()
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]

        var entities = [EntityClass]()
        do{
            entities = try self.mainContext.fetch(fetchRequest) as? [EntityClass] ?? []

        } catch let error as NSError{
            print(error)
        }
        return entities
    }
    
    private func saveContext(_ context:NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
