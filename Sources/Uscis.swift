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
		if CommandLine.argc != 3 {
			consoleIO.writeMessage("\nInvalid arguments count.", to: .error)
			consoleIO.printUsage()
			exit(1)
		}
		
		let arg = CommandLine.arguments[1]
		let option = consoleIO.getArgument(arg.substring(from: arg.characters.index(arg.startIndex,offsetBy:1)))
		
		switch option {
		case .help:
			consoleIO.printUsage()
		case .run:
			consoleIO.writeMessage("Implement code to run as daemon")
		case .status:
			consoleIO.writeMessage("Implement code to check status.")
		case .unknown:
			consoleIO.writeMessage("\nUnknown argument: \(arg).",to: .error)
			consoleIO.printUsage()
		}
		
	}
}
