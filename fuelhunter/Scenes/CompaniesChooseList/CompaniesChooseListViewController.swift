//
//  CompaniesChooseListViewController.swift
//  fuelhunter
//
//  Created by Guntis on 04/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CompaniesChooseListDisplayLogic: class {
  	func displayListWithData(viewModel: CompaniesChooseList.CompanyCells.ViewModel)
}

class CompaniesChooseListViewController: UIViewController, CompaniesChooseListDisplayLogic, UITableViewDelegate, UITableViewDataSource {
  	var interactor: CompaniesChooseListBusinessLogic?
  	var router: (NSObjectProtocol & CompaniesChooseListRoutingLogic & CompaniesChooseListDataPassing)?
	var data = [CompaniesChooseList.CompanyCells.ViewModel.DisplayedCompanyCellItem]()
  	

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
		let interactor = CompaniesChooseListInteractor()
		let presenter = CompaniesChooseListPresenter()
		let router = CompaniesChooseListRouter()
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
    	
		self.title = "Uzpildes kompānijas"
    	
    	
    	self.view.backgroundColor = .white
		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.separatorColor = .clear
//    	tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    	let nib = UINib.init(nibName: "FuelCompanyListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
    	
    	setUpTableViewHeader()
    	
    	getCompaniesListData()
  	}
  	
  	func setUpTableViewHeader() {
  		let headerView = UIView()
		
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = Font.init(.normal, size: .size2).font
		label.textColor = UIColor.init(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 1.0)
		
		let text = "Atzīmē kuras uzpildes kompānijas vēlies redzēt sarakstā."
		let height = text.height(withConstrainedWidth: self.view.frame.width-26, font: Font.init(.normal, size: .size2).font)
		
		label.text = text
		label.frame = CGRect.init(x: 12, y: 10, width: self.view.frame.width-26, height: height+6)
		
		headerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: height+10+6+10)
		
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
		) as? FuelCompanyListCell {
		
			let aData = self.data[indexPath.row]
			cell.selectionStyle = .none
			cell.titleLabel.text = aData.title
			cell.aSwitch.isOn = aData.toggleStatus
			cell.setIconImageFromImageName(imageName: aData.imageName)
			cell.setDescriptionText(descriptionText: aData.description)
			
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

		let alfa = min(100, max(0, scrollView.contentOffset.y+5))/100.0
		
		navBarBottomShadow.alpha = alfa
	}

  	// MARK: Do something

  	//@IBOutlet weak var nameTextField: UITextField!

  	func getCompaniesListData() {
    	let request = CompaniesChooseList.CompanyCells.Request()
    	interactor?.getCompaniesListData(request: request)
  	}

  	func displayListWithData(viewModel: CompaniesChooseList.CompanyCells.ViewModel) {
    	//nameTextField.text = viewModel.name
    	data = viewModel.displayedCompanyCellItems
    	tableView.reloadData()
  	}
}
