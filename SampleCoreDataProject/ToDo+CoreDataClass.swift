//
//  ToDo+CoreDataClass.swift
//  SampleCoreDataProject
//
//  Created by Dmitry Deplov on 23/07/2019.
//  Copyright © 2019 Dmitry Deplov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ToDo)
public class ToDo: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}
