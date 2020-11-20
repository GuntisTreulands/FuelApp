//
//  AreaEditPageViewController.swift
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
import FirebaseCrashlytics

protocol AreaEditPageDisplayLogic: class {
  	func displayData(viewModel: Area.AreaEditPage.ViewModel)
}

class AreaEditPageViewController: UIViewController, AreaEditPageDisplayLogic, AreaEditPageViewLayoutViewLogic {

  	var interactor: AreaEditPageBusinessLogic?
  	var router: (NSObjectProtocol & AreaEditPageRoutingLogic & AreaEditPageDataPassing)?
  	var layoutView: AreaEditPageViewLayoutView!

  	// MARK: Object lifecycle

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    	super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    	setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
    	super.init(coder: aDecoder)
    	setup()
  	}

  	// MARK: View lifecycle

	deinit {
	}

  	override func viewDidLoad() {
    	super.viewDidLoad()
    	self.view.backgroundColor = .white
    	setUpView()

		self.navigationController!.interactivePopGestureRecognizer?.delegate = nil
		self.navigationController!.interactivePopGestureRecognizer?.isEnabled = true
		
    	self.navigationController!.setNavigationBarHidden(false, animated: true)

    	getData()
  	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	// MARK: Set up

	private func setup() {
		let viewController = self
		let interactor = AreaEditPageInteractor()
		let presenter = AreaEditPagePresenter()
		let router = AreaEditPageRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		presenter.router = router
		router.viewController = viewController
		router.dataStore = interactor
  	}

	private func setUpView() {
		layoutView = AreaEditPageViewLayoutView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
	}

	// MARK: AreaEditPageViewLayoutViewLogic

	func toggleCompanyNamed(name: String, state: Bool) {
		let request = Area.ToggleCompanyStatus.Request(companyName: name, state: state)
		interactor?.toggleCompanyNamed(request: request)
	}

	func userJustChangedAreaName(_ name: String) {
		let request = Area.ChangeName.Request(newName: name)
    	interactor?.updateName(request: request)
		self.title = name
	}

	func userJustToggledCheapestOnlySwitch(withState state: Bool) {
		let request = Area.ToggleCheapest.Request(cheapest: state)
    	interactor?.toggleCheapest(request: request)
	}

	func userJustToggledPushNotifSwitch(withState state: Bool) {
		let request = Area.ToggleNotif.Request(notif: state)
		interactor?.togglePushNotif(request: request)
	}

	func deleteWasPressed() {
		let alert = UIAlertController(title: "hey_alert_title".localized(), message: "areas_delete_alert_text".localized(), preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "yes_button_title".localized(), style: .default, handler: { result in
			// Delete
			self.interactor?.deletePressed()
		}))

		alert.addAction(UIAlertAction(title: "cancel_button_title".localized(), style: .cancel, handler: nil))

		self.present(alert, animated: true)
	}

  	// MARK: Functions

  	private func getData() {
    	let request = Area.AreaEditPage.Request()
    	interactor?.getData(request: request)
  	}

	// MARK: AreaEditPageDisplayLogic

  	func displayData(viewModel: Area.AreaEditPage.ViewModel) {
  		layoutView.updateData(data: viewModel.displayedCells)
  		self.title = viewModel.areaName
  	}
}
