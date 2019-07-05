//
//  FuelTypeChooseListInteractor.swift
//  fuelhunter
//
//  Created by Guntis on 05/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FuelTypeChooseListBusinessLogic {
  	func getFuelTypesListData(request: FuelTypeChooseList.FuelCells.Request)
}

protocol FuelTypeChooseListDataStore {
  	//var name: String { get set }
}

class FuelTypeChooseListInteractor: FuelTypeChooseListBusinessLogic, FuelTypeChooseListDataStore {
  	var presenter: FuelTypeChooseListPresentationLogic?
  	var worker: FuelTypeChooseListWorker?
  	//var name: String = ""

  	// MARK: Do something

  	func getFuelTypesListData(request: FuelTypeChooseList.FuelCells.Request) {
    	worker = FuelTypeChooseListWorker()
    	// Get selected status from worker.
    	worker?.doSomeWork()

    	let response = FuelTypeChooseList.FuelCells.Response()
    	presenter?.displayListWithData(response: response)
  	}
}
