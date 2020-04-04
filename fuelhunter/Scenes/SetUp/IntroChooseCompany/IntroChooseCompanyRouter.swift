//
//  IntroChooseCompanyRouter.swift
//  fuelhunter
//
//  Created by Guntis on 19/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol IntroChooseCompanyRoutingLogic {
}

protocol IntroChooseCompanyDataPassing {
  	var dataStore: IntroChooseCompanyDataStore? { get }
}

class IntroChooseCompanyRouter: NSObject, IntroChooseCompanyRoutingLogic, IntroChooseCompanyDataPassing {
  	weak var viewController: IntroChooseCompanyViewController?
  	var dataStore: IntroChooseCompanyDataStore?
}
