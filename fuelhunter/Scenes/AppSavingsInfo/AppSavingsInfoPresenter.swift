//
//  AppSavingsInfoPresenter.swift
//  fuelhunter
//
//  Created by Guntis on 15/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AppSavingsInfoPresentationLogic {
  	func presentSomething(response: AppSavingsInfo.Something.Response)
}

class AppSavingsInfoPresenter: AppSavingsInfoPresentationLogic {
  	weak var viewController: AppSavingsInfoDisplayLogic?

  	// MARK: Do something

  	func presentSomething(response: AppSavingsInfo.Something.Response) {
    	let viewModel = AppSavingsInfo.Something.ViewModel()
    	viewController?.displaySomething(viewModel: viewModel)
  	}
}
