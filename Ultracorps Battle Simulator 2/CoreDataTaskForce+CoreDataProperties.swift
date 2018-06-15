//
//  CoreDataTaskForce+CoreDataProperties.swift
//  Ultracorps Battle Simulator 2
//
//  Created by Darrell Root on 6/15/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreDataTaskForce {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataTaskForce> {
        return NSFetchRequest<CoreDataTaskForce>(entityName: "CoreDataTaskForce")
    }

    @NSManaged public var quantities: Int64
    @NSManaged public var unitIndex: Int64
    @NSManaged public var memberOf: CoreDataFleet?

}
