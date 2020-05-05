//
//  MapWorker.swift
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
import CoreLocation

class MapWorker {
	func createUsableDataArray(fromPricesArray priceArray: [PriceEntity], companiesArray: [CompanyEntity]) -> [Map.MapData.ViewModel.DisplayedMapPoint] {
		var newArray = [Map.MapData.ViewModel.DisplayedMapPoint]()

		let userLocation = AppSettingsWorker.shared.userLocation

		for (_, item) in priceArray.enumerated() {
			let allAddresses = item.addresses?.allObjects as! [AddressEntity]

			if let company = companiesArray.first(where: {$0.companyMetaData?.company == item.companyMetaData?.company})
			{
				for (subIndex, addressItem) in allAddresses.enumerated() {

					var distanceInMeters: Double = -1


					if(AppSettingsWorker.shared.getGPSIsEnabled() && userLocation != nil) {
						let coordinate = CLLocation(latitude: addressItem.latitude, longitude: addressItem.longitude)
						distanceInMeters = userLocation!.distance(from: coordinate);
					}

					newArray.append(Map.MapData.ViewModel.DisplayedMapPoint(id: item.id!, subId: item.id! + String(subIndex), company: company, price: item.price!, isPriceCheapest: item == priceArray.first ? true : false, latitude: addressItem.latitude, longitude: addressItem.longitude, addressName: addressItem.name!, addressDescription: item.addressDescription!, distanceInMeters: Double(addressItem.distanceInMeters), distanceInMetersStraightLine: distanceInMeters, distanceEstimatedTime: addressItem.estimatedTimeInMinutes))
				}
			}
		}

		return newArray.sorted { $0.distanceInMeters < $1.distanceInMeters }
	}

	func getAllAddressesThatNeedsDistanceMeasurement( from priceArray: [PriceEntity]) -> [AddressEntity] {
		var allAddressesObjects = [AddressEntity]()

		for (_, item) in priceArray.enumerated() {
			let allAddresses = item.addresses?.allObjects as! [AddressEntity]
			let filteredAddresses = allAddresses.filter({$0.distanceInMeters == -1})

			if filteredAddresses.isEmpty == false {
				allAddressesObjects.append(contentsOf: filteredAddresses)
			}
		}

		return allAddressesObjects
	}
}
