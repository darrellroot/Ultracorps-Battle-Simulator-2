//
//  CoreDataFleet+CoreDataProperties.swift
//  Ultracorps Battle Simulator 2
//
//  Created by Darrell Root on 6/15/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreDataFleet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataFleet> {
        return NSFetchRequest<CoreDataFleet>(entityName: "CoreDataFleet")
    }

    @NSManaged public var name: String?
    @NSManaged public var member: NSSet?

}

// MARK: Generated accessors for member
extension CoreDataFleet {

    @objc(addMemberObject:)
    @NSManaged public func addToMember(_ value: CoreDataTaskForce)

    @objc(removeMemberObject:)
    @NSManaged public func removeFromMember(_ value: CoreDataTaskForce)

    @objc(addMember:)
    @NSManaged public func addToMember(_ values: NSSet)

    @objc(removeMember:)
    @NSManaged public func removeFromMember(_ values: NSSet)

}
