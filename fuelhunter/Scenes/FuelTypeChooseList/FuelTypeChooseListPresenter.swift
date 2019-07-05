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
  	func displayListWithData(response: FuelTypeChooseList.FuelCells.Response)
}

class FuelTypeChooseListPresenter: FuelTypeChooseListPresentationLogic {
  	weak var viewController: FuelTypeChooseListDisplayLogic?

  	// MARK: Do something
		
  	func displayListWithData(response: FuelTypeChooseList.FuelCells.Response) {
  	
  		let array =  [
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem.init(title: "DD | Dīzeļdegviela", toggleStatus: response.statusOfDD),
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem.init(title: "DD | Pro Dīzeļdegviela", toggleStatus: response.statusOfProDD),
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem.init(title: "95 | Benzīns", toggleStatus: response.statusOf95),
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem.init(title: "98 | Benzīns", toggleStatus: response.statusOf98),
			FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem.init(title: "Auto Gāze", toggleStatus: response.statusOfGas)
			]
			
    	let viewModel = FuelTypeChooseList.FuelCells.ViewModel.init(displayedFuelCellItems: array)
    	viewController?.displayListWithData(viewModel: viewModel)
  	}
}
