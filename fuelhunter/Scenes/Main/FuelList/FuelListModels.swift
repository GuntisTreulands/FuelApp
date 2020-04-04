//
//  FuelListModels.swift
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
import CoreData

enum FuelList {
	// MARK: Use cases

	enum RevealMap {
		struct Request {
			var selectedCompany: CompanyEntity
			var selectedFuelType: FuelType
			var selectedCellYPosition: CGFloat
		}
		struct Response {
			var selectedCompany: CompanyEntity
			var selectedFuelType: FuelType
			var selectedCellYPosition: CGFloat
		}
		struct ViewModel {
			var selectedCompany: CompanyEntity
			var selectedFuelType: FuelType
			var selectedCellYPosition: CGFloat
		}
	}
	enum FetchPrices {
		struct Request {
			var forcedReload: Bool
		}
		struct Response {
			var fetchedPrices: [PriceEntity]
			var insertItems: [IndexPath]
			var deleteItems: [IndexPath]
			var updateItems: [IndexPath]
			var insertSections: [Int]
			var deleteSections: [Int]
			var updateSections: [Int]
		}
		struct ViewModel {
			struct DisplayedPrice: Equatable {
				var id: String
				var company: CompanyEntity
				var price: String
				var isPriceCheapest: Bool
				var fuelType: FuelType
				var addressDescription: String
				var address: [AddressEntity]
				var city: String
			}
			var displayedPrices: [[DisplayedPrice]]
			var insertItems: [IndexPath]
			var deleteItems: [IndexPath]
			var updateItems: [IndexPath]
			var insertSections: [Int]
			var deleteSections: [Int]
			var updateSections: [Int]
		}
	}
	enum FindAPrice {
		struct Request {
			var selectedPrice: PriceEntity
		}
	}
}
