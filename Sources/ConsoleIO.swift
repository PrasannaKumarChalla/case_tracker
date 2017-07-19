//
//  ConsoleIO.swift
//  uscis
//
//  Created by Prasanna Challa on 7/11/17.
//
//

import Foundation

enum Option: String {
	case status = "s"
	case run = "r"
	case help = "h"
	case unknown
}

enum OutputType {
	case error
	case standard
}

class ConsoleIO {
	
	func printUsage () {
		let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
		
		let usage = "\nOVERVIEW:\n\n\tTrack uscis case status.\n" +
			"USAGE:\n\n\t\(executableName) [option] CASENUMBER\n\n" +
			"OPTIONS:\n" +
			"-r\t\t-Runs as daemon and track case status at regular intervals.\n" +
		"-s\t\t-Checks status at his moment.\n"
		
		writeMessage(usage)
	}
	
	func getOption(_ arg: String) -> Option {
		guard let option = Option(rawValue: arg) else {
			return .unknown
		}
		return option
	}
	
	func writeMessage(_ msg: String, to: OutputType = .standard) {
		switch to {
		case .standard:
			print("\u{001B}[;m\(msg)")
		case .error:
			fputs("\u{001B}[0;31m\(msg)\n", stderr)
			print("\u{001B}[;m")
			//print("\n")
		}
	}
	
	func getArguments() -> (uscisCase: UscisCase,option: Option){
		
		if CommandLine.argc != 3 {
			writeMessage("\nInvalid arguments count.", to: .error)
			printUsage()
			exit(1)
		}
		
		let arg1 = CommandLine.arguments[1]
		let option = getOption(arg1.substring(from: arg1.characters.index(arg1.startIndex,offsetBy:1)))
		
		let arg2 = CommandLine.arguments[2]
		let uscisCaseRegex = "^(EAC|WAC|LIN|SRC|NBC|MSC|IOE)\\d{10}$"
		guard arg2.range(of: uscisCaseRegex, options: .regularExpression) != nil else {
			writeMessage("Invalid receipt number, Please check your receipt number and try again", to: .error)
			exit(1)
		}
		let uscisCase = UscisCase(reciptNumber: arg2)
		return (uscisCase:uscisCase, option:option)
		
	}
}
