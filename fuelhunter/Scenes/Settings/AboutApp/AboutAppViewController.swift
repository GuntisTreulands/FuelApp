//
//  AboutAppViewController.swift
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

protocol AboutAppDisplayLogic: class {
  	func displayData(viewModel: AboutApp.CompanyCells.ViewModel)
}

class AboutAppViewController: UIViewController, AboutAppDisplayLogic {
  	var interactor: AboutAppBusinessLogic?
  	var router: (NSObjectProtocol & AboutAppRoutingLogic & AboutAppDataPassing)?
  	var layoutView: AboutAppLayoutView!

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

  	override func viewDidLoad() {
    	super.viewDidLoad()
    	self.title = "settings_about_app_title".localized()
    	self.view.backgroundColor = .white
    	setUpView()
    	getListData()
  	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		let notificationCenter = NotificationCenter.default
		notificationCenter.removeObserver(self)
	}

	// MARK: Set up

  	private func setup() {
		let viewController = self
		let interactor = AboutAppInteractor()
		let presenter = AboutAppPresenter()
		let router = AboutAppRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
  	}

	internal func setUpView() {
		layoutView = AboutAppLayoutView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}

  	// MARK: Functions

	@objc private func appMovedToForeground() {
		layoutView.appMovedToForeground()
	}

	@objc private func appMovedToBackground() {
		layoutView.appMovedToBackground()
	}

  	private func getListData() {
    	let request = AboutApp.CompanyCells.Request()
    	interactor?.getListData(request: request)
  	}

	// MARK: AboutAppDisplayLogic

  	func displayData(viewModel: AboutApp.CompanyCells.ViewModel) {
    	layoutView.updateData(data: viewModel.displayedCompanyCellItems)
  	}
}
