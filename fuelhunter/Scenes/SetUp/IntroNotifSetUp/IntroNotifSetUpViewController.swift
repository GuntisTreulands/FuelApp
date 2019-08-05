//
//  IntroNotifSetUpViewController.swift
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

protocol IntroNotifSetUpDisplayLogic: class {
  	func displaySomething(viewModel: IntroNotifSetUp.Something.ViewModel)
}

class IntroNotifSetUpViewController: UIViewController, IntroNotifSetUpDisplayLogic, IntroNotifSetUpLayoutViewLogic, PushNotifReturnUpdateDataLogic {
  	var interactor: IntroNotifSetUpBusinessLogic?
  	var router: (NSObjectProtocol & IntroNotifSetUpRoutingLogic & IntroNotifSetUpDataPassing)?
	var layoutView: IntroNotifSetUpLayoutView!
  	
  	// MARK: Object lifecycle

  	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    	super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    	setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
    	super.init(coder: aDecoder)
    	setup()
  	}

  	// MARK: Setup

  	private func setup() {
		let viewController = self
		let interactor = IntroNotifSetUpInteractor()
		let presenter = IntroNotifSetUpPresenter()
		let router = IntroNotifSetUpRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		presenter.router = router
		router.viewController = viewController
		router.dataStore = interactor
  	}

  	// MARK: View lifecycle

  	override func viewDidLoad() {
    	super.viewDidLoad()
    	self.view.backgroundColor = .white
    	setUpView()
    	doSomething()
  	}

  	// MARK: Do something

	func setUpView() {
		layoutView = IntroNotifSetUpLayoutView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
	}
	
  	func doSomething() {
    	let request = IntroNotifSetUp.Something.Request()
    	interactor?.doSomething(request: request)
  	}

  	func displaySomething(viewModel: IntroNotifSetUp.Something.ViewModel) {
    	//nameTextField.text = viewModel.name
  	}
  	
  	// MARK: IntroNotifSetUpLayoutViewLogic
  	func giveAccessButtonPressed() {
		let request = IntroNotifSetUp.Something.Request()
		interactor?.userAskedForNotifAccess(request: request)
  	}
  	
  	func laterButtonPressed() {
  		ScenesManager.shared.advanceAppSceneState()
  	}
  	
  	
  	// MARK: PushNotifReturnUpdateDataLogic
	func updateData() {
		ScenesManager.shared.advanceAppSceneState()
	}
}
