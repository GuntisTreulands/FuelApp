//
//  CompaniesChooseListPresenter.swift
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

protocol CompaniesChooseListPresentationLogic {
  	func presentData(response: CompaniesChooseList.CompanyCells.Response)
}

class CompaniesChooseListPresenter: CompaniesChooseListPresentationLogic {
  	weak var viewController: CompaniesChooseListDisplayLogic?
  	
  	// MARK: CompaniesChooseListPresentationLogic

  	func presentData(response:  CompaniesChooseList.CompanyCells.Response) {
		var array = [CompaniesChooseList.CompanyCells.ViewModel.DisplayedCompanyCellItem]()
		let language = AppSettingsWorker.shared.getCurrentLanguage()

		for company in response.fetchedCompanies {
			let languageString: String

			switch language {
				case .latvian:
					languageString = company.descriptionLV ?? ""
				case .russian:
					languageString = company.descriptionRU ?? ""
				case .english:
					languageString = company.descriptionEN ?? ""
				case .latgalian:
					languageString = company.descriptionLV ?? ""
			}

			let title = company.name ?? ""
			let imageName = company.logoName ?? ""

			array.append(CompaniesChooseList.CompanyCells.ViewModel.DisplayedCompanyCellItem(title: title, description: languageString, imageName: imageName, toggleStatus: company.isEnabled))
		}
		
    	let viewModel = CompaniesChooseList.CompanyCells.ViewModel(displayedCompanyCellItems: array, insert: response.insert, delete: response.delete, update: response.update)
    	viewController?.displayListWithData(viewModel: viewModel)
  	}
}
