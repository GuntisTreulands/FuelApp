//
//  AboutAppRouter.swift
//  fuelhunter
//
//  Created by Guntis on 07/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AboutAppRoutingLogic {
  	//func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AboutAppDataPassing {
  	var dataStore: AboutAppDataStore? { get }
}

class AboutAppRouter: NSObject, AboutAppRoutingLogic, AboutAppDataPassing {
  	weak var viewController: AboutAppViewController?
  	var dataStore: AboutAppDataStore?

	// MARK: Routing

	//func routeToSomewhere(segue: UIStoryboardSegue?)
	//{
	//  if let segue = segue {
	//    let destinationVC = segue.destination as! SomewhereViewController
	//    var destinationDS = destinationVC.router!.dataStore!
	//    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
	//  } else {
	//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
	//    let destinationVC = storyboard.instantiateViewController(withIdentifier:
	//   "SomewhereViewController") as! SomewhereViewController
	//    var destinationDS = destinationVC.router!.dataStore!
	//    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
	//    navigateToSomewhere(source: viewController!, destination: destinationVC)
	//  }
	//}
	// MARK: Navigation
	//func navigateToSomewhere(source: AboutAppViewController, destination: SomewhereViewController)
	//{
	//  source.show(destination, sender: nil)
	//}  
	// MARK: Passing data
	//func passDataToSomewhere(source: AboutAppDataStore, destination: inout SomewhereDataStore)
	//{
	//  destination.name = source.name
	//}
}
