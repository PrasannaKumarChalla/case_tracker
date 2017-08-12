//
//  CaseController.swift
//  uscis
//
//  Created by Prasanna challa on 8/11/17.
//
//

import Foundation
import CoreData

struct CaseController {
    private let moc = DataController.persistentContainer.viewContext
    private let console = ConsoleIO()
    func saveCaseStatus(caseNumber: String, status: String) {
        guard let usisCase = fetchCase(caseNumber: caseNumber) else {
            _ = UscisCaseStatus(caseNumber: caseNumber,lastStatus: status, context: moc)
            do {
            try moc.save()
            } catch {
             console.writeMessage("Can't create new case record, error:\(error.localizedDescription)")
            exit(1)
            }
            return
        }
        usisCase.setValue(caseNumber, forKey: "caseNumber")
        usisCase.setValue(status, forKey: "lastStatus")
        usisCase.setValue(Date(), forKey: "lastCheckedDate")
        do {
            try moc.save()
        } catch {
            console.writeMessage("Can't update case record, error:\(error.localizedDescription)")
            exit(1)
        }
    }
    
    func fetchCase(caseNumber: String) -> UscisCaseStatus? {
        let fetchReq = UscisCaseStatus.fetchUscisCaseRequest()
        fetchReq.predicate = NSPredicate(format: "caseNumber == %@", caseNumber)
        do {
        let fetchedCases = try moc.fetch(fetchReq) as [UscisCaseStatus]
        return fetchedCases.first
        } catch {
            console.writeMessage("Can't fetch case record, error:\(error.localizedDescription)")
            exit(1)
        }
        
    }
}
