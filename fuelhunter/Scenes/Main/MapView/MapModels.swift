//
//  MapModels.swift
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

enum MapAppType {
	case Waze
	case GoogleMaps
	case iOSMaps
}

enum Map {
  	// MARK: Use cases

	enum MapNavigationRequested {
		struct Request {
			var mapAppType: MapAppType
		}
	}

	enum MapWasPressed {
		struct Request {
			var mapPoint: MapPoint
		}
		struct Response {
			var selectedDisplayedPoint: MapData.ViewModel.DisplayedMapPoint?
			var selectedMapPoint: MapPoint
			var selectedPrice: PriceEntity
			var cellType: CellBackgroundType
		}
		struct ViewModel {
			var selectedDisplayedPoint: MapData.ViewModel.DisplayedMapPoint?
			var selectedMapPoint: MapPoint
			var selectedPrice: PriceEntity
			var cellType: CellBackgroundType
		}
	}

	enum MapData {
		struct Request {
			var forcedReload: Bool
		}
		struct Response {
			var displayedPoints: [MapData.ViewModel.DisplayedMapPoint]
			var mapPoints: [MapPoint]
			var selectedDisplayedPoint: MapData.ViewModel.DisplayedMapPoint?
			var selectedMapPoint: MapPoint
			var cellType: CellBackgroundType
		}
		struct ViewModel {
			struct DisplayedMapPoint: Equatable {
				var id: String   // this is the price ID
				var subId: String // this is the sub-ID -  which is id + address
				var company: CompanyEntity
				var price: String
				var isPriceCheapest: Bool
				var latitude: Double
				var longitude: Double
				var addressName: String
				var addressDescription: String
				var distanceInMeters: Double
				var distanceInMetersStraightLine: Double
				var distanceEstimatedTime: Double
			}
			
			var displayedPoints: [DisplayedMapPoint]
			var mapPoints: [MapPoint]
			var selectedDisplayedPoint: MapData.ViewModel.DisplayedMapPoint?
			var selectedMapPoint: MapPoint
			var cellType: CellBackgroundType
		}
  	}

  	enum MapPinRefresh {
		struct Request {
		}
		struct Response {
			var mapPoint: MapPoint
		}
		struct ViewModel {
			var mapPoint: MapPoint
		}
  	}
}
