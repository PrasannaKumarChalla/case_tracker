//
//  Uscis.swift
//  uscis
//
//  Created by Prasanna Challa on 7/11/17.
//
//

import Foundation

class Uscis {
	let consoleIO = ConsoleIO()
	
	func run() {
		
		let args = consoleIO.getArguments()
		
		switch args.option {
		case .help:
			consoleIO.printUsage()
		case .run:
			consoleIO.writeMessage("Implement code to run as daemon")
		case .status:
			consoleIO.writeMessage("Implement code to check status.")
		case .unknown:
			consoleIO.writeMessage("\nUnknown argument: \(CommandLine.arguments[1]).",to: .error)
			consoleIO.printUsage()
		}
		
	}
}
