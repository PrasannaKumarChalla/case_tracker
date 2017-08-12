//
//  UscisCaseStatus+CoreDataProperties.swift
//  uscis
//
//  Created by Prasanna challa on 8/8/17.
//
//

import Foundation
import CoreData


extension UscisCaseStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UscisCaseStatus> {
        return NSFetchRequest<UscisCaseStatus>(entityName: "UscisCaseStatus")
    }

    @NSManaged public var caseNumber: String?
    @NSManaged public var lastCheckedDate: NSDate?
    @NSManaged public var lastStatus: String?
    @NSManaged public var relatedCases: NSSet?

}

// MARK: Generated accessors for relatedCases
extension UscisCaseStatus {

    @objc(addRelatedCasesObject:)
    @NSManaged public func addToRelatedCases(_ value: UscisCaseStatus)

    @objc(removeRelatedCasesObject:)
    @NSManaged public func removeFromRelatedCases(_ value: UscisCaseStatus)

    @objc(addRelatedCases:)
    @NSManaged public func addToRelatedCases(_ values: NSSet)

    @objc(removeRelatedCases:)
    @NSManaged public func removeFromRelatedCases(_ values: NSSet)

}
