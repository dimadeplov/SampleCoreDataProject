//
//  SampleCoreDataProjectTests.swift
//  SampleCoreDataProjectTests
//
//  Created by Dmitry Deplov on 18/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//

import XCTest
import CoreData
@testable import SampleCoreDataProject

class SampleCoreDataProjectTests: XCTestCase {
    
    lazy var managedObjectModel:NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
    }()
    
    lazy var stack:CoreDataStack = {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        return CoreDataStack(persistentStoreDescription: description, model: managedObjectModel)
    }()
    
    lazy var stubDataManager:DataManager = {
        return DataManager(context: stack.managedObjectContext)
    }()
    
    
    var dataManager:DataManager!
    override func setUp() {
        super.setUp()
        
        func createStubFolder(folderName:String, todosNames:[String]?) {
            
            let folder = Folder(context:stack.managedObjectContext)
            folder.name = folderName
            if let todos = todosNames {
                for name in todos {
                    let todo = ToDo(context: stack.managedObjectContext)
                    todo.name = name
                    folder.addToTodos(todo)
                }
            }
        }
        
        createStubFolder(folderName: "Folder #1", todosNames: ["Todo #1","Todo #2","Todo #3"])
        createStubFolder(folderName: "Folder #2", todosNames: nil)
        createStubFolder(folderName: "Folder #3", todosNames: nil)
        do {
            try stack.managedObjectContext.save()
        }  catch {
            XCTFail("Can't create stub data, error:\(error)")
        }
        dataManager = DataManager(context: stack.managedObjectContext)
        
    }

    override func tearDown() {
        let request = Folder.request
        
        let folders = try! stack.managedObjectContext.fetch(request)
        
        for folder in folders {
            stack.managedObjectContext.delete(folder)
        }
        try! stack.managedObjectContext.save()
        
        super.tearDown()
    }
    
    func testGetFolders() {
        let folders = dataManager.getFolders()
        XCTAssertEqual(folders.count, 3)
    }

    
    func testCreateNewFolder() {
        dataManager.createNewFolder(name: "Folder #4")
        XCTAssertEqual(numberOfFoldersInStore(), 4)
    }
    
    func testDeleteFolder() {
        let folder = dataManager.getFolders()[0]
        dataManager.deleteFolder(folder)
        
        XCTAssertEqual(numberOfFoldersInStore(), 2)
    }
    
    func testUpdateFolder() {
        let folder = dataManager.getFolders()[0]
        let folderID = folder.objectID
        dataManager.updateFolder(folder, newName: "Updated Folder Name")
        
        let refetchedFolder = stack.managedObjectContext.object(with: folderID) as? Folder

        XCTAssertEqual(refetchedFolder?.name, folder.name)
    }
    
    
    func testCreateNewToDo() {
        let folder = dataManager.getFolders()[0]
        let todosCount = folder.todos?.count ?? 0
        dataManager.createNewToDo(name: "New Todo", inFolder: folder)
        
        let refetchedFolder = stack.managedObjectContext.object(with: folder.objectID) as? Folder
        
        XCTAssertEqual(refetchedFolder?.todos?.count, todosCount + 1)
        
    }
    
    
    func testDeleteToDo() {
        
        do {
            let todo = try stack.managedObjectContext.fetch(ToDo.request)[0]
            let folder = todo.folder
            let todosCount = folder.todos?.count ?? 0
            _ = dataManager.deleteToDo(todo)
            
            let refetchedFolder = stack.managedObjectContext.object(with: folder.objectID) as? Folder
            XCTAssertEqual(refetchedFolder?.todos?.count, todosCount - 1)
        }
        catch {
            XCTFail("Can't fetch ToDo error:\(error)")
        }
        
    }
    
    func testUpdateToDo() {
        
        do {
            let todo = try stack.managedObjectContext.fetch(ToDo.request)[0]
            dataManager.updateToDo(todo, newName: "Updated ToDo Name", done:!todo.done)

            let refetchedToDo = stack.managedObjectContext.object(with: todo.objectID) as? ToDo
            XCTAssertEqual(refetchedToDo?.name, todo.name)
            XCTAssertEqual(refetchedToDo?.done, todo.done)
        }
        catch {
            XCTFail("Can't fetch ToDo error:\(error)")
        }
        
    }
    
    func testFetchResultControllerForFolders() {
        let fRC = dataManager.fetchResultControllerForFolders()
        XCTAssertNotNil(fRC)
    }
    
    func numberOfFoldersInStore() -> Int {
        let request = Folder.request
        let folders = try! stack.managedObjectContext.fetch(request)
        return folders.count
    }
    
}
