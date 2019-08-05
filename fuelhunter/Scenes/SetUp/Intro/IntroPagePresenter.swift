//
//  IntroPagePresenter.swift
//  fuelhunter
//
//  Created by Guntis on 16/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol IntroPagePresentationLogic {
  	func presentSomething(response: IntroPage.Something.Response)
}

public class IntroPagePresenter: IntroPagePresentationLogic {
  	weak var viewController: IntroPageDisplayLogic?

  	// MARK: Do something

  	func presentSomething(response: IntroPage.Something.Response) {
    	let viewModel = IntroPage.Something.ViewModel()
    	viewController?.displaySomething(viewModel: viewModel)
  	}
}
