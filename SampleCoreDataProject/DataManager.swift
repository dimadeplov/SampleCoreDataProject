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
        saveContext(mainContext)
    }
    
    func deleteFolder(_ folder:Folder) {
        mainContext.delete(folder)
        saveContext(mainContext)
    }
    
    func updateFolder(_ folder:Folder, newName name:String) {
        folder.name = name
        saveContext(mainContext)
    }
    

    func fetchResultControllerForFolders() -> NSFetchedResultsController<Folder> {
        let sortDescriptors = [Folder.primarySortDescriptor()]
        
        return fetchResultsControllerFor(Folder.self, sortDescriptors: sortDescriptors) as! NSFetchedResultsController<Folder>
    }
    
    func createNewToDo(name:String, inFolder folder:Folder) {
        let toDoEntity = ToDo(context: mainContext)
        toDoEntity.name = name
        folder.addToTodos(toDoEntity)
        saveContext(mainContext)
    }
    
    func deleteToDo(_ todo:ToDo) -> Folder {
        let folder = todo.folder
        folder.removeFromTodos(todo)
        
        mainContext.delete(todo)
        saveContext(mainContext)
        return folder
    }
    
    func updateToDo(_ todo:ToDo, newName name:String) {
        todo.name = name
        saveContext(mainContext)
    }
    
    
    //MARK: - Private Methods
    
    private func getEntities<EntityClass:NSManagedObject>(_ entityClass:EntityClass.Type) -> [EntityClass] {
    
        let fetchRequest = entityClass.fetchRequest()
        var entities = [EntityClass]()
        do{
            entities = try self.mainContext.fetch(fetchRequest) as? [EntityClass] ?? []
        } catch let error as NSError{
            print(error)
        }
        return entities
    }
    
    private func fetchResultsControllerFor<EntityClass:NSManagedObject>(_ entityClass:EntityClass.Type, sortDescriptors:[NSSortDescriptor], predicate:NSPredicate?=nil) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let request = entityClass.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.mainContext, sectionNameKeyPath: nil, cacheName: nil)
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
