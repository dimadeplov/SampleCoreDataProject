//
//  Folder+CoreDataClass.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 23/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    
    enum FolderSortDescriptors:String {
        case byCreationDate = "creationDate"
        case byName = "name"
    }
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
    
    func getToDoAt(index:Int) -> ToDo? {
        if let todosOrderedSet = todos, index >= 0 && index < todosOrderedSet.count  {
            return todosOrderedSet.object(at: index) as? ToDo
        }
        return nil
    }

    class func primarySortDescriptor() -> NSSortDescriptor {
        return NSSortDescriptor(key: FolderSortDescriptors.byCreationDate.rawValue, ascending: false)
    }
    
    
    
    
}
