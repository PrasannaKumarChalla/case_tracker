//
//  UscisCaseStatus+CoreDataClass.swift
//  uscis
//
//  Created by Prasanna challa on 8/8/17.
//
//

import Foundation
import CoreData

@objc(UscisCaseStatus)
public class UscisCaseStatus: NSManagedObject {
    convenience init(caseNumber:String, lastStatus:String = "unknown", context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "UscisCaseStatus", in: context) {
            self.init(entity: entity, insertInto: context)
            self.caseNumber = caseNumber
            self.lastStatus = lastStatus
            self.lastCheckedDate = NSDate()
            //self.relatedCases = nil
        } else {
            fatalError("Can't initialize uscis case.")
        }
    }
    
   class func fetchUscisCaseRequest() -> NSFetchRequest<UscisCaseStatus> {
        return NSFetchRequest<UscisCaseStatus>(entityName: "UscisCaseStatus")
    }
    
}
