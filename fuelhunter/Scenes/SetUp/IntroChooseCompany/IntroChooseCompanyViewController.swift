//
//  IntroChooseCompanyViewController.swift
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

protocol IntroChooseCompanyDisplayLogic: class {
  	func displayListWithData(viewModel: IntroChooseCompany.CompanyCells.ViewModel)
}

class IntroChooseCompanyViewController: UIViewController, IntroChooseCompanyDisplayLogic, IntroChooseCompanyLayoutViewLogic {

  	var interactor: IntroChooseCompanyBusinessLogic?
  	var router: (NSObjectProtocol & IntroChooseCompanyRoutingLogic & IntroChooseCompanyDataPassing)?
	var layoutView: IntroChooseCompanyLayoutView!

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
    	self.view.backgroundColor = .white
    	setUpView()
    	getData()
  	}

  	// MARK: Set up

  	private func setup() {
		let viewController = self
		let interactor = IntroChooseCompanyInteractor()
		let presenter = IntroChooseCompanyPresenter()
		let router = IntroChooseCompanyRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
  	}

  	func setUpView() {
		layoutView = IntroChooseCompanyLayoutView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
	}

  	// MARK: Functions

  	func getData() {
    	let request = IntroChooseCompany.CompanyCells.Request()
    	interactor?.getCompaniesListData(request: request)
  	}

  	func displayListWithData(viewModel: IntroChooseCompany.CompanyCells.ViewModel) {
  		layoutView.updateData(data: viewModel.displayedCompanyCellItems, insert: viewModel.insert, delete: viewModel.delete, update: viewModel.update)
  	}

  	// MARK: IntroChooseCompanyLayoutViewLogic

	func switchWasPressedFor(companyName: String, withState state: Bool) {
		let request = IntroChooseCompany.SwitchToggled.Request(companyName: companyName, state: state)
		interactor?.userToggledCompanyType(request: request)
	}

  	func nextButtonWasPressed() {
  		ScenesManager.shared.advanceAppSceneState()
  	}
}
