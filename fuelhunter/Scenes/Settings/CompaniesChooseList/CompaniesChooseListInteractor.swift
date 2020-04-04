//
//  CompaniesChooseListInteractor.swift
//  fuelhunter
//
//  Created by Guntis on 04/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData

protocol CompaniesChooseListBusinessLogic {
  	func getCompaniesListData(request: CompaniesChooseList.CompanyCells.Request)
  	func userToggledCompanyType(request: CompaniesChooseList.SwitchToggled.Request)
  	func didUserAddACompany() -> Bool
}

protocol CompaniesChooseListDataStore {
  	//var name: String { get set }
}

class CompaniesChooseListInteractor: NSObject, CompaniesChooseListBusinessLogic, CompaniesChooseListDataStore, NSFetchedResultsControllerDelegate {

  	var presenter: CompaniesChooseListPresentationLogic?
	var fetchedResultsController: NSFetchedResultsController<CompanyEntity>!
	var insert = [IndexPath]()
	var delete = [IndexPath]()
	var update = [IndexPath]()
	var previousFetchedCompanies: [CompanyEntity]?

	var companiesThatWereEnabled = [String]()


  	// MARK: CompaniesChooseListBusinessLogic

  	func getCompaniesListData(request: CompaniesChooseList.CompanyCells.Request) {

		if fetchedResultsController == nil {
			let context = DataBaseManager.shared.mainManagedObjectContext()
			let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "isHidden == \(false)")
			let sort = NSSortDescriptor(key: "order", ascending: true)
			fetchRequest.sortDescriptors = [sort]
			fetchRequest.propertiesToFetch = ["isEnabled"]
			fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

			fetchedResultsController.delegate = self
		}

		var fetchedCompanies: [CompanyEntity]?

		do {
			try fetchedResultsController.performFetch()

			fetchedCompanies = fetchedResultsController.fetchedObjects
		} catch let error {
			// Something went wrong
			print("Something went wrong. \(error)")
		}

		// First of all - if no insert/delete, then no need to update last cell
		// Second of all, only if cell that needs updating - is now (but was not) / is not anymore (but was) last cell - we update it.
		if !insert.isEmpty || !delete.isEmpty {
			if let previousFetchedCompanies = previousFetchedCompanies, !previousFetchedCompanies.isEmpty {
				if let fetchedCompanies = fetchedCompanies, !fetchedCompanies.isEmpty {
					if(previousFetchedCompanies.last != fetchedCompanies.last)
					{
						//--- Extra logic. We need to update previous last cell
						if let previousLastCompanyIndex = fetchedCompanies.firstIndex(of: previousFetchedCompanies.last!) {
							let indexPath = IndexPath.init(row: previousLastCompanyIndex, section: 0)
							if !update.contains(indexPath) { update.append(indexPath) }
						}
						//===

						//--- Extra logic. We need to update new last cell
						if let newLastCompanyIndex = previousFetchedCompanies.firstIndex(of: fetchedCompanies.last!) {
							let indexPath = IndexPath.init(row: newLastCompanyIndex, section: 0)
							if !update.contains(indexPath) { update.append(indexPath) }
						}
						//===
					}
				}
			}
		}

		previousFetchedCompanies = fetchedCompanies

		let response = CompaniesChooseList.CompanyCells.Response(fetchedCompanies: fetchedCompanies ?? [], insert: insert, delete: delete, update: update)
    	presenter?.presentData(response: response)
  	}

  	func userToggledCompanyType(request: CompaniesChooseList.SwitchToggled.Request) {

		let task = {
			let context = DataBaseManager.shared.mainManagedObjectContext()

			let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

			fetchRequest.predicate = NSPredicate(format: "isHidden == \(false) && name == %@", request.companyName)
			fetchRequest.propertiesToFetch = ["isEnabled"]

			do {
				let fetchedCompanies = try context.fetch(fetchRequest)

				if fetchedCompanies.isEmpty {
					// Problem
				} else {
					// Now we need to toggle enable status for selected company.
					// And then check all other companies, and toggle chepest, if needed.
					let selectedCompany = fetchedCompanies.first!
					selectedCompany.isEnabled = request.state

					if selectedCompany.isEnabled == true {
						self.companiesThatWereEnabled.append(selectedCompany.name!)
					} else {
						self.companiesThatWereEnabled.removeAll(where: {$0 == selectedCompany.name})
					}

					fetchRequest.predicate = NSPredicate(format: "isCheapestToggle == \(true)")
					fetchRequest.propertiesToFetch = ["isEnabled"]
					let cheapestCompaniesArray = try context.fetch(fetchRequest)


					if cheapestCompaniesArray.isEmpty {
						// Problem
					} else {
						let cheapestCompany = cheapestCompaniesArray.first!

						// If cheapest is disabled, then we need to re-calculate all.
						if cheapestCompany.isEnabled == false {
							fetchRequest.predicate = NSPredicate(format: "isHidden == \(false) && isCheapestToggle == \(false)")
							fetchRequest.propertiesToFetch = ["isEnabled"]
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
									self.companiesThatWereEnabled.append(cheapestCompany.name!)
								}
							}
						}
						// else, all is good.
					}
					
					DataBaseManager.shared.saveContext()

					NotificationCenter.default.post(name: .settingsUpdated, object: nil)
				}

			} catch let error {
				print("Something went wrong. \(error) Sentry Report!")
			}
		}

		DataBaseManager.shared.addATask(action: task)
  	}
  	
	// If we just remove fuel types and leave view, then it's fine (as we have data covered it).
	// But if we add new type, then we better re-download all.
  	func didUserAddACompany() -> Bool {
		return !companiesThatWereEnabled.isEmpty
  	}

	// MARK: NSFetchedResultsControllerDelegate
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		insert.removeAll()
		update.removeAll()
		delete.removeAll()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
			case .insert:
				if let newIndexPath = newIndexPath {
					insert.append(newIndexPath)
				}
			case .delete:
				if let indexPath = indexPath {
					delete.append(indexPath)
				}
			case .update:
				if let indexPath = indexPath {
					update.append(indexPath)
				}
			case .move:
				if let indexPath = indexPath, let newIndexPath = newIndexPath {
					delete.append(indexPath)
					insert.append(newIndexPath)
				}
			default:
				break
		}
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		getCompaniesListData(request: CompaniesChooseList.CompanyCells.Request())
		insert.removeAll()
		update.removeAll()
		delete.removeAll()
	}
}
