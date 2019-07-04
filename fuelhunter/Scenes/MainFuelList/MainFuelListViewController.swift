//
//  MainFuelListViewController.swift
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


protocol MainFuelListDisplayLogic: class {
	func displaySomething(viewModel: MainFuelList.FetchPrices.ViewModel)
}

class MainFuelListViewController: UIViewController, MainFuelListDisplayLogic, UITableViewDelegate, UITableViewDataSource {
	
	var interactor: MainFuelListBusinessLogic?
	var router: (NSObjectProtocol & MainFuelListRoutingLogic & MainFuelListDataPassing)?
	var data = [[MainFuelList.FetchPrices.ViewModel.DisplayedPrice]]()
	 
	@IBOutlet weak var inlineAlertView: InlineAlertView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var navBarBottomShadow: UIImageView!
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
		let interactor = MainFuelListInteractor()
		let presenter = MainFuelListPresenter()
		let router = MainFuelListRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}

	// MARK: Routing

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let scene = segue.identifier {
			let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
			if let router = router, router.responds(to: selector) {
				router.perform(selector, with: segue)
			}
		}
	}

	// MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		getData()

		self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image:
			UIImage.init(named: "Settings_icon"), style: .plain, target: router, action:NSSelectorFromString("routeToSettings"))
		self.title = "Fuel Hunter"
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    	self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.isTranslucent = true

    	self.view.backgroundColor = .white

    	tableView.delegate = self
    	tableView.dataSource = self
    	tableView.separatorColor = .clear
    	tableView.contentInset = UIEdgeInsets.init(top: -6, left: 0, bottom: -9, right: 0)
    	let nib = UINib.init(nibName: "FuelListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
	}

	// MARK: Table view
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let cell = tableView.dequeueReusableCell(
		   withIdentifier: "cell",
		   for: indexPath
		) as? FuelListCell {
		
			let aData = self.data[indexPath.section][indexPath.row]
			
			cell.titleLabel.text = aData.companyName
			cell.addressesLabel.text = aData.addressDescription
			cell.iconImageView.image = UIImage.init(named: aData.companyLogoName)
			cell.priceLabel.text = aData.price
			
			if aData.isPriceCheapest == true {
				cell.priceLabel.textColor = UIColor.init(named: "CheapPriceColor") 
			} else {
				cell.priceLabel.textColor = UIColor.init(named: "TitleColor")
			}
			
			cell.selectionStyle = .none
				
			if self.data[indexPath.section].count == 1 {
				cell.setAsCellType(cellType: .single)
			} else {
				if self.data[indexPath.section].first == aData {
					cell.setAsCellType(cellType: .top)
				} else if self.data[indexPath.section].last == aData {
					cell.setAsCellType(cellType: .bottom)
				} else {
					cell.setAsCellType(cellType: .middle)
				}
			}
			return cell
		} else {
			// Problem
			return UITableViewCell.init()
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let aData = self.data[section].first!
			
		let baseView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 60))
		
		let label: UILabel = UILabel()
		label.text = aData.gasType.rawValue
		label.font = Font.init(.medium, size: .size3).font
		label.textColor = UIColor.init(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 1.0)
		
		let height = aData.gasType.rawValue.height(withConstrainedWidth: self.view.frame.width-26, font: Font.init(.medium, size: .size3).font)
		
		label.frame = CGRect.init(x: 12, y: 20, width: self.view.frame.width-26, height: height+6)
		
		baseView.addSubview(label)
		
		print(label)
		
		return baseView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		let aData = self.data[section].first!
		let height = aData.gasType.rawValue.height(withConstrainedWidth: self.view.frame.width-26, font: Font.init(.medium, size: .size3).font)
		
		return height + 26
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
	
		return 0
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {

		let alfa = min(100, max(0, scrollView.contentOffset.y-15))/100.0
		
		navBarBottomShadow.alpha = alfa
	}
	
	// MARK: Do something

	func getData() {
		let request = MainFuelList.FetchPrices.Request()
		interactor?.fetchPrices(request: request)
	}

	func displaySomething(viewModel: MainFuelList.FetchPrices.ViewModel) {
		//nameTextField.text = viewModel.name
		data = viewModel.displayedPrices
		tableView.reloadData()
		
	}
}
