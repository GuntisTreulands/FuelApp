//
//  FuelTypeChooseListViewController.swift
//  fuelhunter
//
//  Created by Guntis on 05/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FuelTypeChooseListDisplayLogic: class {
  	func displayListWithData(viewModel: FuelTypeChooseList.FuelCells.ViewModel)
}

class FuelTypeChooseListViewController: UIViewController, FuelTypeChooseListDisplayLogic, UITableViewDelegate, UITableViewDataSource {
	
  	var interactor: FuelTypeChooseListBusinessLogic?
  	var router: (NSObjectProtocol & FuelTypeChooseListRoutingLogic & FuelTypeChooseListDataPassing)?
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var navBarBottomShadow: UIImageView!
	@IBOutlet weak var tableViewBottomShadow: UIImageView!
	var data = [FuelTypeChooseList.FuelCells.ViewModel.DisplayedFuelCellItem]()
  	var activateShadowUpdates = false
  	
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
		let interactor = FuelTypeChooseListInteractor()
		let presenter = FuelTypeChooseListPresenter()
		let router = FuelTypeChooseListRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
  	}

  	// MARK: View lifecycle

  	override func viewDidLoad() {
    	super.viewDidLoad()
    	
		self.title = "Degvielas veids"
    	
    	
    	self.view.backgroundColor = .white
		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.separatorColor = .clear
    	tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
    	let nib = UINib.init(nibName: "FuelTypeListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
    	
    	setUpTableViewHeader()
    	
    	getCompaniesListData()
  	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		activateShadowUpdates = true
	}
	 	
  	func setUpTableViewHeader() {
  		let headerView = UIView()
		
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = Font.init(.normal, size: .size2).font
		label.textColor = UIColor.init(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 1.0)
		
		let text = "Atzīmē degvielas veidus, kuru cenas Tevi interesē"
		let height = text.height(withConstrainedWidth: self.view.frame.width-26, font: Font.init(.normal, size: .size2).font)
		
		label.text = text
		label.frame = CGRect.init(x: 12, y: 10, width: self.view.frame.width-26, height: height+6)
		
		headerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: height+26)
		
		headerView.addSubview(label)
		tableView.tableHeaderView = headerView
  	}
  	
  	// MARK: Table view
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let cell = tableView.dequeueReusableCell(
		   withIdentifier: "cell",
		   for: indexPath
		) as? FuelTypeListCell {
		
			let aData = self.data[indexPath.row]
			cell.selectionStyle = .none
			cell.titleLabel.text = aData.title
			cell.aSwitch.isOn = aData.toggleStatus
			
			if self.data.count == 1 {
				cell.setAsCellType(cellType: .single)
			} else {
				if self.data.first == aData {
					cell.setAsCellType(cellType: .top)
				} else if self.data.last == aData {
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
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
	
		return 0
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
	
		return 0
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
  	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if activateShadowUpdates == true {
			adjustVisibilityOfShadowLines()
		}
	}
	
	func adjustVisibilityOfShadowLines() {
		let alfa = min(50, max(0, tableView.contentOffset.y))/50.0
		
		navBarBottomShadow.alpha = alfa
		
		let value = tableView.contentOffset.y+tableView.frame.size.height-tableView.contentInset.bottom-tableView.contentInset.top

		let alfa2 = min(50, max(0, tableView.contentSize.height-value))/50.0
		
		tableViewBottomShadow.alpha = alfa2
	}

  	// MARK: Do something
  	func getCompaniesListData() {
    	let request = FuelTypeChooseList.FuelCells.Request()
    	interactor?.getFuelTypesListData(request: request)
  	}

  	func displayListWithData(viewModel: FuelTypeChooseList.FuelCells.ViewModel) {
    	data = viewModel.displayedFuelCellItems
    	tableView.reloadData()
		tableView.layoutIfNeeded()
		adjustVisibilityOfShadowLines()
  	}
}
