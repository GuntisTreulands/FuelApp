//
//  MapRouter.swift
//  fuelhunter
//
//  Created by Guntis on 12/08/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MapReturnUpdateDataLogic: class {
  	func justSelectedACell(atIndexPath indexPath: IndexPath) -> CGFloat
}

@objc protocol MapRoutingLogic {
  	//func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MapDataPassing {
  	var dataStore: MapDataStore? { get set }
  	var previousViewController: MapReturnUpdateDataLogic? { get set }
}

class MapRouter: NSObject, MapRoutingLogic, MapDataPassing {
  	weak var viewController: MapViewController?
  	var dataStore: MapDataStore?
  	var previousViewController: MapReturnUpdateDataLogic?
}
