//
//  Folder+CoreDataProperties.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 05/08/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var creationDate: Date
    @NSManaged public var folderDescription: String?
    @NSManaged public var name: String
    @NSManaged public var todos: NSOrderedSet?

}

// MARK: Generated accessors for todos
extension Folder {

    @objc(insertObject:inTodosAtIndex:)
    @NSManaged public func insertIntoTodos(_ value: ToDo, at idx: Int)

    @objc(removeObjectFromTodosAtIndex:)
    @NSManaged public func removeFromTodos(at idx: Int)

    @objc(insertTodos:atIndexes:)
    @NSManaged public func insertIntoTodos(_ values: [ToDo], at indexes: NSIndexSet)

    @objc(removeTodosAtIndexes:)
    @NSManaged public func removeFromTodos(at indexes: NSIndexSet)

    @objc(replaceObjectInTodosAtIndex:withObject:)
    @NSManaged public func replaceTodos(at idx: Int, with value: ToDo)

    @objc(replaceTodosAtIndexes:withTodos:)
    @NSManaged public func replaceTodos(at indexes: NSIndexSet, with values: [ToDo])

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: ToDo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: ToDo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSOrderedSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSOrderedSet)

}
