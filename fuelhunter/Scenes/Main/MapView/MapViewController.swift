//
//  MapViewController.swift
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

protocol MapDisplayLogic: class {
  	func displaySomething(viewModel: Map.MapData.ViewModel)
  	func updateToRevealMapPoint(viewModel: Map.MapWasPressed.ViewModel)
}

class MapViewController: UIViewController, MapDisplayLogic, FuelListToMapViewPushTransitionAnimatorHelperProtocol, FuelListToMapViewPopTransitionAnimatorHelperProtocol, MapLayoutViewViewLogic {
  	var interactor: MapBusinessLogic?
  	var router: (NSObjectProtocol & MapRoutingLogic & MapDataPassing)?
	var layoutView: MapLayoutView!
	var fuelCellView: FuelListCellView!
	var tempYOffset: CGFloat = 0
	var yOffSetConstraint: NSLayoutConstraint!

	var draggedOffset: CGFloat = 0

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
    	self.title = router?.dataStore?.selectedFuelType.rawValue.localized()
    	setUpView()
    	doSomething()
    	
    	layoutView.alpha = 0
  	}
	
	override func viewSafeAreaInsetsDidChange() {
		super.viewSafeAreaInsetsDidChange()
		self.fuelCellView.safeLayoutBottomInset = self.view.safeAreaInsets.bottom
		if let location = router?.dataStore?.yLocation {
			yOffSetConstraint.constant = location
		}
	}
	
	// MARK: Set up

  	private func setup() {
		let viewController = self
		let interactor = MapInteractor()
		let presenter = MapPresenter()
		let router = MapRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
  	}

	func setUpView() {
		layoutView = MapLayoutView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.controller = self
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

		fuelCellView = FuelListCellView.init(frame: CGRect.init(x: 0, y: 100, width: self.view.frame.width, height: 100))

		fuelCellView.safeLayoutBottomInset = self.view.safeAreaInsets.bottom
		self.view.addSubview(fuelCellView)

		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(fuelCellViewWasDragged(_:)))
		fuelCellView.addGestureRecognizer(panGesture)

		yOffSetConstraint = fuelCellView.topAnchor.constraint(equalTo: self.view.topAnchor)
		yOffSetConstraint.isActive = true
		fuelCellView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
		fuelCellView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
	}

	@objc func fuelCellViewWasDragged(_ sender: UIPanGestureRecognizer) {
//		if(sender.state == UIGestureRecognizer.State.began)
//		{
//			layoutView.layer.removeAllAnimations()
//		}

		if(sender.state == UIGestureRecognizer.State.ended)
		{
//			UIImpactFeedbackGenerator(style: .light).impactOccurred()

			let duration: TimeInterval = TimeInterval(max(0.05, min(0.3, draggedOffset/100)))

//			print(duration)

			UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
				self.view.layoutIfNeeded()
				self.yOffSetConstraint.constant = self.view.frame.height - self.fuelCellView.frame.height
				self.view.layoutIfNeeded()

				self.layoutView.updateMapViewOffset(offset: self.view.frame.height - self.yOffSetConstraint.constant - self.view.safeAreaInsets.bottom, animated: true)
			}, completion: { success in })
		} else {

			let translation = sender.translation(in: self.view)
			self.yOffSetConstraint.constant = self.yOffSetConstraint.constant + translation.y/2
			sender.setTranslation(CGPoint.zero, in: self.view)
			layoutView.updateMapViewOffset(offset: self.view.frame.height - self.yOffSetConstraint.constant - self.view.safeAreaInsets.bottom, animated: false)

			draggedOffset = abs((self.view.frame.height - self.fuelCellView.frame.height) - (self.yOffSetConstraint.constant))
		}

	}
  	// MARK: Functions

  	func doSomething() {
    	let request = Map.MapData.Request()
    	interactor?.doSomething(request: request)
  	}

	func updateData(to priceData: Map.MapData.ViewModel.DisplayedMapPoint, mapPoint: MapPoint) {

		let aData = router?.dataStore?.selectedPricesArray!.first(where: {$0.company == router?.dataStore?.selectedCompany}) ?? router?.dataStore?.selectedPricesArray?.first

		layoutView.selectedPin(mapPoint)

		if router?.dataStore?.selectedPricesArray?.count == 1 {
			fuelCellView.updateDataWithData(priceData: priceData, mapPointData: mapPoint, andCellType: .single)
		} else {
			if router?.dataStore?.selectedPricesArray?.first == aData {
				fuelCellView.updateDataWithData(priceData: priceData, mapPointData: mapPoint, andCellType: .top)
			} else if router?.dataStore?.selectedPricesArray?.last == aData {
				fuelCellView.updateDataWithData(priceData: priceData, mapPointData: mapPoint, andCellType: .bottom)
			} else {
				fuelCellView.updateDataWithData(priceData: priceData, mapPointData: mapPoint, andCellType: .middle)
			}
		}
	}

	// MARK: MapDisplayLogic

  	func displaySomething(viewModel: Map.MapData.ViewModel) {
    	self.layoutView.updateMapView(with: viewModel.mapPoints, andOffset:self.fuelCellView.frame.height)
		updateData(to: viewModel.selectedDisplayedPoint!, mapPoint: viewModel.selectedMapPoint)
  	}

  	func updateToRevealMapPoint(viewModel: Map.MapWasPressed.ViewModel) {

		self.updateData(to: viewModel.selectedDisplayedPoint!, mapPoint: viewModel.selectedMapPoint)

		let newYValue = self.router?.previousViewController?.justSelected(fuelPrice: viewModel.selectedPrice)

		self.router?.dataStore?.yLocation = newYValue!


		UIView.animate(withDuration: 0.2) {
			self.view.layoutIfNeeded()
			self.yOffSetConstraint.constant = self.view.frame.height - self.fuelCellView.frame.height
			self.view.layoutIfNeeded()
		}

		self.layoutView.updateMapViewOffset(offset: self.view.frame.height - self.yOffSetConstraint.constant - self.view.safeAreaInsets.bottom, animated: true)
  	}
  	
  	// MARK: FuelListToMapViewPushTransitionAnimatorHelperProtocol
  	
  	func reveal(withDuration duration: TimeInterval, completionHandler: @escaping ((CustomNavigationTransitionResult<Bool>) -> Void)) {

  		if let location = router?.dataStore?.yLocation {
			yOffSetConstraint.constant = location
		}
		self.view.layoutIfNeeded()

  		UIView.animate(withDuration: duration) {
			self.layoutView.alpha = 1
			self.view.layoutIfNeeded()
		}
		
		UIView.animate(withDuration: duration*2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: [.curveEaseInOut], animations: {
			self.fuelCellView.setUpConstraintsAsBottomView()
			self.view.layoutIfNeeded()
			self.yOffSetConstraint.constant = self.view.frame.height - self.fuelCellView.frame.height
			self.view.layoutIfNeeded()
		}, completion: { (finished: Bool) in
			completionHandler(.success)
		})

		self.layoutView.updateMapViewOffset(offset: self.fuelCellView.frame.height - self.view.safeAreaInsets.bottom, animated: false)
  	}
  	
  	// MARK: FuelListToMapViewPopTransitionAnimatorHelperProtocol
  	
  	func hide(withDuration duration: TimeInterval, completionHandler: @escaping ((CustomNavigationTransitionResult<Bool>) -> Void)) {
  		tempYOffset = self.yOffSetConstraint.constant
  		
		UIView.animate(withDuration: duration/2) {
			self.layoutView.alpha = 0
			self.view.layoutIfNeeded()
		}

		UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: [.curveEaseInOut], animations: {
			if let location = self.router?.dataStore?.yLocation {
				if location != -1 {
					self.yOffSetConstraint.constant = location
					self.fuelCellView.setUpConstraintsAsCell()
				} else { // Means we did not find location, means we can't animate to return. So, just fade.
					self.fuelCellView.alpha = 0
				}
			}
			self.view.layoutIfNeeded()
		}, completion: { (finished: Bool) in
			completionHandler(.success)
		})
	}
	
  	func reset() {
  		self.yOffSetConstraint.constant = tempYOffset
  		self.fuelCellView.setUpConstraintsAsBottomView()
  	}

  	// MARK: MapLayoutViewViewLogic

  	func mapPinWasPressed(_ mapPoint: MapPoint) {
		let request = Map.MapWasPressed.Request(mapPoint: mapPoint)
    	interactor?.userPressedOnMapPin(request: request)
	}
}
