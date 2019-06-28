//
//  MainFuelListPresenter.swift
//  fuelhunter
//
//  Created by Guntis on 03/06/2019.
//  Copyright (c) 2019 myEmerg. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainFuelListPresentationLogic {
	func presentSomething(response: MainFuelList.FetchPrices.Response)
}

class MainFuelListPresenter: MainFuelListPresentationLogic {
	weak var viewController: MainFuelListDisplayLogic?

	// MARK: Do something

	func presentSomething(response: MainFuelList.FetchPrices.Response) {
		
		var displayedPrices: [[MainFuelList.FetchPrices.ViewModel.DisplayedPrice]] = []
		
		let type95Prices = self.getPrices(with: .type95, from: response.prices)
		
		let type98Prices = self.getPrices(with: .type98, from: response.prices)
		
		let typeDDPrices = self.getPrices(with: .typeDD, from: response.prices)
		
		let typeDDProPrices = self.getPrices(with: .typeDDPro, from: response.prices)
		
		let typeGasPrices = self.getPrices(with: .typeGas, from: response.prices)
		
		if type95Prices.count > 0 {
			displayedPrices.append(type95Prices)
		}
		if type98Prices.count > 0 {
			displayedPrices.append(type98Prices)
		}
		if typeDDPrices.count > 0 {
			displayedPrices.append(typeDDPrices)
		}
		if typeDDProPrices.count > 0 {
			displayedPrices.append(typeDDProPrices)
		}
		if typeGasPrices.count > 0 {
			displayedPrices.append(typeGasPrices)
		}
    
		let viewModel = MainFuelList.FetchPrices.ViewModel(displayedPrices: displayedPrices)
		viewController?.displaySomething(viewModel: viewModel)
	}
	
	func getPrices(with type: GasType, from prices: [Price]) -> [MainFuelList.FetchPrices.ViewModel.DisplayedPrice] {
    	var pricesToReturn: [MainFuelList.FetchPrices.ViewModel.DisplayedPrice] = []
    	
    	for aPrice in prices {
    		if aPrice.gasType == type {
				let displayedPrice = MainFuelList.FetchPrices.ViewModel.DisplayedPrice.init(id: aPrice.id, companyName: aPrice.companyName, companyLogoName: aPrice.companyLogoName, price: aPrice.price, isPriceCheapest: aPrice.isPriceCheapest, gasType: aPrice.gasType, addressDescription: aPrice.addressDescription)
				pricesToReturn.append(displayedPrice)
			}
		}
		
		return pricesToReturn	
	}
}
