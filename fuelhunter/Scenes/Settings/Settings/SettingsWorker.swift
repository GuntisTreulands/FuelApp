//
//  SettingsWorker.swift
//  fuelhunter
//
//  Created by Guntis on 27/06/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData

class SettingsWorker {

	func getCompanyNames(fromFetchedCompanies: [CompanyEntity]) -> String {

		if fromFetchedCompanies.isEmpty {
			// Problem, because at least Cheapest should be returned.
			return ""
		} else {
			var combinedString = ""
			for aCompany in fromFetchedCompanies {
				let companyName = aCompany.name ?? " "
				combinedString.append("\(companyName.localized()), ")
			}

			if combinedString.count > 0 { combinedString.removeLast() }
			if combinedString.count > 0 { combinedString.removeLast() }

			return combinedString
		}
	}
}
