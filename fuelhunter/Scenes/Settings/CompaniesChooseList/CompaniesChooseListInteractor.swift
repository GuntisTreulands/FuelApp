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
  	func userToggledCompanyType(request: CompaniesChooseList.SwitchToggled.Request)
}

protocol CompaniesChooseListDataStore {
  	//var name: String { get set }
}

class CompaniesChooseListInteractor: CompaniesChooseListBusinessLogic, CompaniesChooseListDataStore {
  	var presenter: CompaniesChooseListPresentationLogic?
  	var appSettingsWorker = AppSettingsWorker.shared
  	//var name: String = ""

  	// MARK: CompaniesChooseListBusinessLogic

  	func getCompaniesListData(request: CompaniesChooseList.CompanyCells.Request) {
  		let companies = appSettingsWorker.getCompanyToggleStatus()
		let response = CompaniesChooseList.CompanyCells.Response(companyCheapestStatus: companies.typeCheapest, companyNesteStatus: companies.typeNeste, companyCircleKStatus: companies.typeCircleK, companyKoolStatus: companies.typeKool, companyLatvijasNaftaStatus: companies.typeLn, companyVirsiStatus: companies.typeVirsi, companyGotikaStatus: companies.typeGotikaAuto)
    	presenter?.presentSomething(response: response)
  	}

  	func userToggledCompanyType(request: CompaniesChooseList.SwitchToggled.Request) {
  		var companies = appSettingsWorker.getCompanyToggleStatus()

  		if request.companyType == .typeCheapest { companies.typeCheapest = request.state }
  		if request.companyType == .typeNeste { companies.typeNeste = request.state }
  		if request.companyType == .typeCircleK { companies.typeCircleK = request.state }
  		if request.companyType == .typeKool { companies.typeKool = request.state }
  		if request.companyType == .typeLN { companies.typeLn = request.state }
  		if request.companyType == .typeVirsi { companies.typeVirsi = request.state }
  		if request.companyType == .typeGotikaAuto { companies.typeGotikaAuto = request.state }

  		appSettingsWorker.setCompanyToggleStatus(allCompanies: companies)

  		let request = CompaniesChooseList.CompanyCells.Request()
    	getCompaniesListData(request: request)
  	}
}
