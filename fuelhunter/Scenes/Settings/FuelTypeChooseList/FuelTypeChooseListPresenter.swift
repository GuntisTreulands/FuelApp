//
//  FuelTypeChooseListPresenter.swift
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

protocol FuelTypeChooseListPresentationLogic {
  	func presentData(response: FuelTypeChooseList.FuelCells.Response)
}

class FuelTypeChooseListPresenter: FuelTypeChooseListPresentationLogic {
  	weak var viewController: FuelTypeChooseListDisplayLogic?

  	// MARK: FuelTypeChooseListPresentationLogic

  	func presentData(response: FuelTypeChooseList.FuelCells.Response) {
  		let array =  [
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .typeDD, title: "fuel_dd", toggleStatus: response.statusOfDD),
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .type95, title: "fuel_95", toggleStatus: response.statusOf95),
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .type98, title: "fuel_98", toggleStatus: response.statusOf98),
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .typeGas, title: "fuel_gas", toggleStatus: response.statusOfGas)
			]

    	let viewModel = FuelTypeChooseList.FuelCells.ViewModel(displayedFuelCellItems: array)
    	viewController?.displayListWithData(viewModel: viewModel)
  	}
}
