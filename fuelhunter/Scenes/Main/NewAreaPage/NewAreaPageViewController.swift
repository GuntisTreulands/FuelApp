//
//  NewAreaPageViewController.swift
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

protocol NewAreaPageDisplayLogic: class {
  	func updateData()
}

class NewAreaPageViewController: UIViewController, NewAreaPageLayoutViewLogic, NewAreaPageDisplayLogic, AreaSetUpPageReturnUpdateDataLogic {
  	var interactor: NewAreaPageBusinessLogic?
  	var router: (NSObjectProtocol & NewAreaPageViewRoutingLogic & NewAreaPagetDataPassing)?
	var layoutView: NewAreaPageLayoutView!

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
    	self.view.backgroundColor = .clear
    	setUpViews()
		getData()
  	}

  	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	// MARK: Set up

  	private func setup() {
		let viewController = self
		let interactor = NewAreaPageViewInteractor()
		let presenter = NewAreaPagePresenter()
		let router = NewAreaPageRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		presenter.router = router
		router.viewController = viewController
  	}

  	private func setUpViews() {
		layoutView = NewAreaPageLayoutView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
	}

	// MARK: Functions

	private func getData() {
		interactor?.getDataToShow()
	}

	// MARK: NewAreaPageDisplayLogic

	func updateData() {
		layoutView.updateData()
	}

	// MARK: NewAreaPageLayoutViewLogic

	func setUpButtonPressed() {
  		router?.routeToSetUp()
  	}
}
