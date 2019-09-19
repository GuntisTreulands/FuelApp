//
//  MapPresenter.swift
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
import MapKit

protocol MapPresentationLogic {
  	func presentSomething(response: Map.MapData.Response)
}

class MapPresenter: MapPresentationLogic {
  	weak var viewController: MapDisplayLogic?

  	// MARK: Do something

  	func presentSomething(response: Map.MapData.Response) {
		let mapPoints = createMapPoints(from: response.displayedPoints)
		let viewModel = Map.MapData.ViewModel(displayedPoints: response.displayedPoints, mapPoints: mapPoints)
    	viewController?.displaySomething(viewModel: viewModel)
  	}

  	func createMapPoints(from data: [Map.MapData.ViewModel.DisplayedMapPoint]) -> [MapPoint] {
  		let points: [MapPoint] = data.map { MapPoint.init(title: $0.companyName, coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude), info: $0.price) }

  		return points
  	}
}
