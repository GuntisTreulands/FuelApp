//
//  IntroChooseCompanyInteractor.swift
//  fuelhunter
//
//  Created by Guntis on 19/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData

protocol IntroChooseCompanyBusinessLogic {
  	func getCompaniesListData(request: IntroChooseCompany.CompanyCells.Request)
  	func userToggledCompanyType(request: IntroChooseCompany.SwitchToggled.Request)
}

protocol IntroChooseCompanyDataStore {
  	//var name: String { get set }
}

class IntroChooseCompanyInteractor: IntroChooseCompanyBusinessLogic, IntroChooseCompanyDataStore {
  	var presenter: IntroChooseCompanyPresentationLogic?
  	var appSettingsWorker = AppSettingsWorker.shared;
  	//var name: String = ""

  	// MARK: IntroChooseCompanyBusinessLogic

  	func getCompaniesListData(request: IntroChooseCompany.CompanyCells.Request) {
//  		let companies = appSettingsWorker.getCompanyToggleStatus()

  		let context = DataBaseManager.shared.mainManagedObjectContext()

		let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

		var fetchedCompanies: [CompanyEntity]?

		let sort = NSSortDescriptor(key: "order", ascending: true)
		fetchRequest.sortDescriptors = [sort]

		do {
			fetchedCompanies = try context.fetch(fetchRequest)
		} catch let error {
			// Something went wrong
			print("Something went wrong. Reseting. \(error)")
		}

		let response = IntroChooseCompany.CompanyCells.Response(fetchedCompanies: fetchedCompanies ?? [])
    	presenter?.presentData(response: response)
  	}

  	func userToggledCompanyType(request: IntroChooseCompany.SwitchToggled.Request) {

		let context = DataBaseManager.shared.mainManagedObjectContext()

		let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

		fetchRequest.predicate = NSPredicate(format: "name == %@", request.companyName)

		do {
			let fetchedCompanies = try context.fetch(fetchRequest)

			if fetchedCompanies.isEmpty {
				// Problem
			} else {
				// Now we need to toggle enable status for selected company.
				// And then check all other companies, and toggle chepest, if needed.
				let selectedCompany = fetchedCompanies.first!
				selectedCompany.isEnabled = request.state

				fetchRequest.predicate = NSPredicate(format: "isCheapestToggle == %i", true)
				let cheapestCompaniesArray = try context.fetch(fetchRequest)

				if cheapestCompaniesArray.isEmpty {
					// Problem
				} else {
					let cheapestCompany = cheapestCompaniesArray.first!

					// If cheapest is disabled, then we need to re-calculate all.
					if cheapestCompany.isEnabled == false {
						fetchRequest.predicate = NSPredicate(format: "isCheapestToggle == %i", false)
						let allExceptCheapestCompaniesArray = try context.fetch(fetchRequest)

						if allExceptCheapestCompaniesArray.isEmpty {
							// Problem
						} else {
							var isAtLeastOneEnabled = false

							for aCompany in allExceptCheapestCompaniesArray {
								if aCompany.isEnabled == true {
									isAtLeastOneEnabled = true
									break
								}
							}
							// If none was enabled, then set as true.
							if isAtLeastOneEnabled == false {
								cheapestCompany.isEnabled = true
							}
						}
					}
					// else, all is good.
				}

				DataBaseManager.shared.saveContext()
			}

		} catch let error {
			print("Something went wrong. \(error)")
		}

		let request = IntroChooseCompany.CompanyCells.Request()
    	getCompaniesListData(request: request)
  	}
}
