//
//  AppLanguageInteractor.swift
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

protocol AppLanguageBusinessLogic {
  	func getLanaguageListData(request: AppLanguage.GetLanguage.Request)
  	func userSelectedLanguage(request: AppLanguage.ChangeLanguage.Request)
}

protocol AppLanguageDataStore {
}

class AppLanguageInteractor: AppLanguageBusinessLogic, AppLanguageDataStore {
  	var presenter: AppLanguagePresentationLogic?

  	// MARK: AppLanguageBusinessLogic

  	func getLanaguageListData(request: AppLanguage.GetLanguage.Request) {
    	let response = AppLanguage.GetLanguage.Response(activeLanguage: AppSettingsWorker.shared.getCurrentLanguage())
    	presenter?.presentLanguageList(response: response)
  	}

  	func userSelectedLanguage(request: AppLanguage.ChangeLanguage.Request) {
		if AppSettingsWorker.shared.getCurrentLanguage() != request.selectedLanguage {
			AppSettingsWorker.shared.setCurrentLanguage(request.selectedLanguage)

			let response = AppLanguage.GetLanguage.Response(activeLanguage: request.selectedLanguage)
			presenter?.presentLanguageList(response: response)
		}
  	}
}
