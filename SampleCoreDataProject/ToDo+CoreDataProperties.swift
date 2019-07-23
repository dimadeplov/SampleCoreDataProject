//
//  ToDo+CoreDataProperties.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 23/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var name: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var done: Bool
    @NSManaged public var folder: Folder?

}
