//
//  FuelListViewController.swift
//  fuelhunter
//
//  Created by Guntis on 03/06/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol FuelListDisplayLogic: class {
	func updateCityView(viewModel: FuelList.UpdateCityView.ViewModel)
	func displayData(viewModel: FuelList.FetchPrices.ViewModel)
	func revealMapView(viewModel: FuelList.RevealMap.ViewModel)
}

class FuelListViewController: UIViewController, FuelListDisplayLogic, FuelListLayoutViewLogic, MapReturnUpdateDataLogic, FuelListToMapViewPopTransitionAnimatorFinaliseHelperProtocol, ClosestCityNameButtonViewButtonLogic {

	var interactor: FuelListBusinessLogic?
	var router: (NSObjectProtocol & FuelListRoutingLogic & FuelListDataPassing)?
	var layoutView: FuelListLayoutView!
	var selectedCell: FuelListCell?
	
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
    	NotificationCenter.default.removeObserver(self, name: .languageWasChanged, object: nil)
    	NotificationCenter.default.removeObserver(self, name: .fontSizeWasChanged, object: nil)
    	NotificationCenter.default.removeObserver(self, name: .settingsUpdated, object: nil)
    	NotificationCenter.default.removeObserver(self, name: .checkForCompanyChanges, object: nil)
    	NotificationCenter.default.removeObserver(self, name: .cityNameUpdated, object: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController!.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image:
			UIImage(named: "Settings_icon"), style: .plain, target: router, action:NSSelectorFromString("routeToSettings"))
		self.navigationController!.navigationBar.topItem?.title = "fuel_list_app_name".localized()
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    	self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.isTranslucent = true
    	self.view.backgroundColor = .white

    	NotificationCenter.default.addObserver(self, selector: #selector(languageWasChanged),
    		name: .languageWasChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(fontSizeWasChanged),
    		name: .fontSizeWasChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(settingsUpdated),
    		name: .settingsUpdated, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(checkForCompanyChanges),
			name: .checkForCompanyChanges, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(cityNameUpdated),
		name: .cityNameUpdated, object: nil)

		setUpView()
		getData()
		
		checkForCompanyChanges()

		// For testing... for now..
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//			let destinationVC = CompanyChangesViewController()
//			destinationVC.providesPresentationContextTransitionStyle = true
//			destinationVC.definesPresentationContext = true
//			destinationVC.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
//			self.present(destinationVC, animated: true) { }
//		}

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getCityViewData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		layoutView.adjustVisibilityOfShadowLines()
	}

	//MARK: Set up

	private func setup() {
		let viewController = self
		let interactor = FuelListInteractor()
		let presenter = FuelListPresenter()
		let router = FuelListRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}

	private func setUpView() {
		layoutView = FuelListLayoutView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
	}

	// MARK: Functions

	private func getData() {
		let request = FuelList.FetchPrices.Request(forcedReload: false)
		interactor?.fetchPrices(request: request)
	}

	private func getCityViewData() {
		let request = FuelList.UpdateCityView.Request()
		interactor?.updateCityView(request: request)
	}

	// MARK: FuelListDisplayLogic

	func updateCityView(viewModel: FuelList.UpdateCityView.ViewModel) {
		layoutView.updateCity(viewModel.currentCityName, gpsIconVisible: viewModel.currentCityGPSIconEnabled)
	}

	func displayData(viewModel: FuelList.FetchPrices.ViewModel) {
		layoutView.updateData(data: viewModel.displayedPrices, insertItems: viewModel.insertItems, deleteItems: viewModel.deleteItems, updateItems: viewModel.updateItems, insertSections: viewModel.insertSections, deleteSections: viewModel.deleteSections, updateSections: viewModel.updateSections)
	}

	func revealMapView(viewModel: FuelList.RevealMap.ViewModel) {
		router?.routeToMapView(atYLocation: viewModel.selectedCellYPosition, selectedFuelCompany: viewModel.selectedCompany, selectedFuelType: viewModel.selectedFuelType)
	}

	// MARK: FuelListLayoutViewLogic

	func savingsButtonPressed() {
		router?.routeToAppSavingsInfo()
	}

	func accuracyButtonPressed() {
		router?.routeToAppAccuracyInfo()
	}

	func pressedOnACell(atYLocation yLocation: CGFloat, forCell cell: FuelListCell, forCompany company: CompanyEntity, forSelectedFuelType fuelType: FuelType) {
		selectedCell = cell
		selectedCell?.isHidden = true

		let request = FuelList.RevealMap.Request(selectedCompany: company, selectedFuelType: fuelType, selectedCellYPosition: yLocation)

		interactor?.prepareToRevealMapWithRequest(request:request)
	}

	func closestCityNameButtonWasPressed() {
		router?.revealCityNameExplainView()
	}
	
	// MARK: FuelListToMapViewPopTransitionAnimatorFinaliseHelperProtocol
	
	func customTransitionWasFinished() {
		selectedCell?.isHidden = false
	}

	// MARK: MapReturnUpdateDataLogic

	func justSelected(fuelPrice: PriceEntity) -> CGFloat {
		var indexPath: IndexPath?

		selectedCell?.isHidden = false
		selectedCell = nil;

		outerLoop: for(sectionIndex, array) in layoutView.data.enumerated() {
			for(rowIndex, price) in array.enumerated() {
				if price.fuelType.rawValue != fuelPrice.fuelType { break; }

				if price.company == fuelPrice.companyMetaData?.company {
					indexPath = IndexPath(row: rowIndex, section: sectionIndex)
					if let cell = layoutView.tableView.cellForRow(at: indexPath!) {
						// We found a cell!
						selectedCell = cell as? FuelListCell
						let cellRect = layoutView.tableView.rectForRow(at: indexPath!)
						if !layoutView.tableView.bounds.contains(cellRect) {
							// Cell is partly visible. So we scroll to reveal it fully. Just a nicety
							if cellRect.origin.y > layoutView.tableView.bounds.origin.y {
								layoutView.tableView.scrollToRow(at: indexPath!, at: .bottom, animated: false)
							} else {
								layoutView.tableView.scrollToRow(at: indexPath!, at: .top, animated: false)
							}
						}
					} else {
						// No cell. So, we scroll to middle, to reveal it.
						layoutView.tableView.scrollToRow(at: indexPath!, at: .middle, animated: false)
						if let cell = layoutView.tableView.cellForRow(at: indexPath!) {
							selectedCell = cell as? FuelListCell
						}
					}
					break outerLoop
				}
			}
		}

		if let indexPath = indexPath, let selectedCell = selectedCell {
			selectedCell.isHidden = true
			let rect = layoutView.tableView.rectForRow(at: indexPath)
			let rectInScreen = layoutView.tableView.convert(rect, to: self.view)
			return rectInScreen.origin.y
		}

		// Means we did not find location, means we can't animate to return. So, return -1, which will just fade.
		return -1
	}

	// MARK: Notifications

	@objc private func languageWasChanged() {
		getData()
	}

	@objc private func fontSizeWasChanged() {
		self.layoutView.resetUI()
		getCityViewData()
	}

	@objc private func settingsUpdated() {
		let request = FuelList.FetchPrices.Request(forcedReload: true)
		interactor?.fetchPrices(request: request)
	}

	@objc private func checkForCompanyChanges() {
		if interactor?.checkIfThereAreCompanyChangesToPresent() == true {
			router?.revealCompanyChanges()
		}
	}

	@objc private func cityNameUpdated() {
		getCityViewData()
	}

}
