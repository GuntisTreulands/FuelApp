//
//  SettingsInteractor.swift
//  fuelhunter
//
//  Created by Guntis on 27/06/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData
import FirebaseCrashlytics
protocol SettingsBusinessLogic {
  	func getSettingsCellsData(request: Settings.SettingsList.Request)
  	func userPressedOnGpsSwitch()
}

protocol SettingsDataStore {
  	//var name: String { get set }
}

class SettingsInteractor: NSObject, SettingsBusinessLogic, SettingsDataStore {
  	var presenter: SettingsPresentationLogic?
  	var settingsWorker = SettingsWorker()

	// MARK: SettingsBusinessLogic

  	func getSettingsCellsData(request: Settings.SettingsList.Request) {

		let gpsIsEnabledStatus = AppSettingsWorker.shared.getGPSIsEnabled()
		let fuelTypeNames = AppSettingsWorker.shared.getFuelTypeToggleStatus().description

		let response = Settings.SettingsList.Response(fuelTypeNames: fuelTypeNames, gpsIsEnabledStatus: gpsIsEnabledStatus)
		presenter?.presentSettingsListWithData(response: response)
  	}

  	func userPressedOnGpsSwitch() {
  		AppSettingsWorker.shared.userPressedButtonToGetGPSAccess { result in
  			switch result {
  				case .firstTime:
					// All good, but reload data.
					let request = Settings.SettingsList.Request()
					self.getSettingsCellsData(request: request)
				case .secondTime:
					UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
			}
		}
  	}
}
