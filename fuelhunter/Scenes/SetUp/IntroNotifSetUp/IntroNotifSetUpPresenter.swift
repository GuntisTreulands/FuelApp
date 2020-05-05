//
//  IntroNotifSetUpPresenter.swift
//  fuelhunter
//
//  Created by Guntis on 25/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol IntroNotifSetUpPresentationLogic {
  	func showNotifSetUp(response: IntroNotifSetUp.PushNotif.Response)
}

class IntroNotifSetUpPresenter: IntroNotifSetUpPresentationLogic {
  	weak var router: IntroNotifSetUpRouter?
	
  	// MARK: IntroNotifSetUpPresentationLogic

  	func showNotifSetUp(response: IntroNotifSetUp.PushNotif.Response) {
  		router?.presentNotifSetUpScene(response: response)
  	}
}
