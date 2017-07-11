//
//  ConsoleIO.swift
//  uscis
//
//  Created by Prasanna Challa on 7/11/17.
//
//

import Foundation

enum Argument: String {
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
	
	func getArgument(_ arg: String) -> Argument {
		guard let argument = Argument(rawValue: arg) else {
			return .unknown
		}
		return argument
	}
	
	func writeMessage(_ msg: String, to: OutputType = .standard) {
		switch to {
		case .standard:
			print("\u{001B}[;m\(msg)")
		case .error:
			fputs("\u{001B}[0;31m\(msg)\n", stderr)
		}
	}
}
