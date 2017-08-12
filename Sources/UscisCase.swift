//
//  UscisCase.swift
//  uscis
//
//  Created by Prasanna Challa on 7/11/17.
//
//

import Foundation

struct UscisCase {
	
	let reciptNumber: String
	let consoleIO = ConsoleIO()
    let caseController = CaseController()
    static let dispatchGroup = DispatchGroup.init()
    
	init?(reciptNumber: String) {
		guard UscisCase.isValidReciptNumber(reciptNumber) else {
			return nil
		}
		self.reciptNumber = reciptNumber
	}
	//will send a POST req, fetches result, will parse it and filter the status using regex.
	func getStatus() {
        UscisCase.dispatchGroup.enter()
		self.urlTask().resume()
	}
    
    func getStatusWithRelatedCases() throws {
        for uscisCase in try self.relatedCases() {
            uscisCase.getStatus()
        }
        UscisCase.dispatchGroup.notify(queue: .global()) {
            do {
            for relatedCase in try self.relatedCases() {
                guard let uscisCase = self.caseController.fetchCase(caseNumber: relatedCase.reciptNumber) else {
                    self.consoleIO.writeMessage("Can't print by fetching cases.")
                    exit(1)
                }
                self.consoleIO.writeMessage("\(uscisCase.lastCheckedDate!)-\(uscisCase.caseNumber!):\(uscisCase.lastStatus!)")
            }
            } catch {
                self.consoleIO.writeMessage("Error occured while trying to print uscis cases.\(error.localizedDescription)")
                exit(1)
            }
            exit(0)
        }
    }
    
    func urlTask() -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: self.getRequestForCaseNumber()) { (data, response, error) in
            guard let data = data, error == nil else {
                self.consoleIO.writeMessage("Networking Error:\(error.debugDescription)", to: .error)
                UscisCase.dispatchGroup.leave()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                self.consoleIO.writeMessage("Error Requesting Case Status: Error Code:\(httpStatus.statusCode), error:\(response.debugDescription)", to: .error)
            }
            guard let responseStr = String(data: data, encoding: .utf8) else {
                self.consoleIO.writeMessage("Can't parse result as string.", to: .error)
                UscisCase.dispatchGroup.leave()
                return
            }
            guard let status = self.parseStatus(responseStr) else {
                self.consoleIO.writeMessage("Can't find status in the reponse.", to: .error)
                UscisCase.dispatchGroup.leave()
                return
            }
            //instead of writing to console save it to coredata
            //self.consoleIO.writeMessage("\(self.reciptNumber): \(status)")
            self.caseController.saveCaseStatus(caseNumber: self.reciptNumber, status: status)
            UscisCase.dispatchGroup.leave()
        }
        return task
        
    }
    
	func parseStatus(_ html: String) -> String? {
		let consoleIO = ConsoleIO()
		
		
		/* Regex:
		*/
		let pattern = "<strong>Your Current Status:<\\/strong>\\s*(?<patt>[^<]+?)\\s*<span"
		
		guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
			consoleIO.writeMessage("Invalid regex",to: .error)
			return nil
		}
		let textRange = NSMakeRange(0, html.utf16.count)
		let matches = regex.matches(in: html, range: textRange)
		
        let status = (html as NSString).substring(with: matches[0].rangeAt(1))
        if status.isEmpty {
			consoleIO.writeMessage("Couldn't crawl status from the response.",to: .error)
			return nil
		}
		return status

	}
	
	func relatedCases() throws -> [UscisCase] {
		var cases = [UscisCase]()
		let suffix = self.reciptNumber.substring(from: self.reciptNumber.index(self.reciptNumber.startIndex, offsetBy: 3))
		guard let numberSuffix = Int(suffix) else {
			throw CustomError.errorCalculatingRelatedCases
		}
		for i in (numberSuffix-5)...(numberSuffix+5) {
			let uscisCase = "\(self.caseCenterCode())"+String(describing: i)
			guard let validCase = UscisCase(reciptNumber: uscisCase) else {
				throw CustomError.errorCalculatingRelatedCases
			}
			cases.append(validCase)
		}
		return cases
	}
	
	func caseCenterCode() -> String {
		return self.reciptNumber.substring(to: self.reciptNumber.index(self.reciptNumber.startIndex, offsetBy: 3))
	}
	
	static func isValidReciptNumber(_ str: String) -> Bool {
		let uscisCaseRegex = "^(EAC|WAC|LIN|SRC|NBC|MSC|IOE)\\d{10}$"
		guard str.range(of: uscisCaseRegex, options: .regularExpression) != nil else {
			return false
		}
		return true
	}
    
    func getRequestForCaseNumber() -> URLRequest {
        var request = URLRequest(url: URL(string: "https://egov.uscis.gov/casestatus/mycasestatus.do")!)
        request.httpMethod = "POST"
        let formData = "appReceiptNum=\(self.reciptNumber)"
        request.httpBody = formData.data(using: .utf8)
        return request
    }
}
