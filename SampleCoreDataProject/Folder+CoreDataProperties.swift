//
//  Folder+CoreDataProperties.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 23/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var anchors: NSOrderedSet?

}

// MARK: Generated accessors for anchors
extension Folder {

    @objc(insertObject:inAnchorsAtIndex:)
    @NSManaged public func insertIntoAnchors(_ value: ToDo, at idx: Int)

    @objc(removeObjectFromAnchorsAtIndex:)
    @NSManaged public func removeFromAnchors(at idx: Int)

    @objc(insertAnchors:atIndexes:)
    @NSManaged public func insertIntoAnchors(_ values: [ToDo], at indexes: NSIndexSet)

    @objc(removeAnchorsAtIndexes:)
    @NSManaged public func removeFromAnchors(at indexes: NSIndexSet)

    @objc(replaceObjectInAnchorsAtIndex:withObject:)
    @NSManaged public func replaceAnchors(at idx: Int, with value: ToDo)

    @objc(replaceAnchorsAtIndexes:withAnchors:)
    @NSManaged public func replaceAnchors(at indexes: NSIndexSet, with values: [ToDo])

    @objc(addAnchorsObject:)
    @NSManaged public func addToAnchors(_ value: ToDo)

    @objc(removeAnchorsObject:)
    @NSManaged public func removeFromAnchors(_ value: ToDo)

    @objc(addAnchors:)
    @NSManaged public func addToAnchors(_ values: NSOrderedSet)

    @objc(removeAnchors:)
    @NSManaged public func removeFromAnchors(_ values: NSOrderedSet)

}
