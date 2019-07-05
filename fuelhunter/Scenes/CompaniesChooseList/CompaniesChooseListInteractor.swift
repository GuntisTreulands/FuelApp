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

protocol CompaniesChooseListBusinessLogic {
  	func getCompaniesListData(request: CompaniesChooseList.CompanyCells.Request)
}

protocol CompaniesChooseListDataStore {
  	//var name: String { get set }
}

class CompaniesChooseListInteractor: CompaniesChooseListBusinessLogic, CompaniesChooseListDataStore {
  	var presenter: CompaniesChooseListPresentationLogic?
//  	var worker: CompaniesChooseListWorker?
  	//var name: String = ""

  	// MARK: Do something

  	func getCompaniesListData(request: CompaniesChooseList.CompanyCells.Request) {
//    	worker = CompaniesChooseListWorker()
//    	worker?.doSomeWork()

		// Get selected status from worker
		
    	let response = CompaniesChooseList.CompanyCells.Response()
    	presenter?.presentSomething(response: response)
  	}
}
