//
//  CompanyChangesRouter.swift
//  fuelhunter
//
//  Created by Guntis on 10/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol CompanyChangesRoutingLogic {
  	func dismissCurrentViewController()
}

protocol CompanyChangesDataPassing {
  	var dataStore: CompanyChangesDataStore? { get }
}

class CompanyChangesRouter: NSObject, CompanyChangesRoutingLogic, CompanyChangesDataPassing {
	weak var viewController: CompanyChangesViewController?
  	var dataStore: CompanyChangesDataStore?

	// MARK: CompanyChangesRoutingLogic

	func dismissCurrentViewController() {
		viewController?.dismiss(animated: true, completion: { })
	}
}
