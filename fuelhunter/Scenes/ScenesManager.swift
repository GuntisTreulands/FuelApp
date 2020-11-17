//
//  ScenesManager.swift
//  fuelhunter
//
//  Created by Guntis on 16/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

enum AppSceneState: Int {
	case introPageFirstView = 0
	case introPageChooseFuelType = 1
	case introPageGPSAccessAsking = 2
	case mainList = 3
}

class ScenesManager: NSObject {

	static let shared = ScenesManager()

	private override init() {
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(fontSizeWasChanged), name: .fontSizeWasChanged, object: nil)
	}

	weak var window: UIWindow?

	// MARK: Functions

	func setRootViewController(animated: Bool) {
		var destinationVC: UIViewController?

  		let sceneState = ScenesManager.shared.getAppSceneState()

  		switch sceneState {
			case .introPageFirstView:
				destinationVC = IntroPageViewController()
			case .introPageChooseFuelType:
				destinationVC = IntroChooseFuelTypeViewController()
			case .introPageGPSAccessAsking:
				destinationVC = IntroGPSSetUpViewController()
			default:
				if(AppSettingsWorker.shared.getGPSIsEnabled() == false) {
					DataDownloader.shared.activateProcess()
				}
				destinationVC = MainViewsListViewController()
		}

  		let rootVc = ScenesManager.shared.window?.rootViewController as! UINavigationController  		
  		rootVc.setViewControllers([destinationVC!], animated: animated)

		switch sceneState {
			case .mainList:
				rootVc.setNavigationBarHidden(false, animated: animated)
			default:
				rootVc.setNavigationBarHidden(true, animated: animated)
		}
	}

	func advanceAppSceneState() {
		var sceneState = ScenesManager.shared.getAppSceneState()

		if sceneState != .mainList {
			sceneState = AppSceneState(rawValue: sceneState.rawValue+1)!
			ScenesManager.storeAppSceneState(state: sceneState)
			
			ScenesManager.shared.setRootViewController(animated: true)
		} else {
			print("This should not happen. Scene is already max")
		}
	}

	func getAppSceneState() -> AppSceneState {
		return AppSceneState(rawValue: UserDefaults.standard.integer(forKey: "app_scene_state")) ?? AppSceneState.introPageFirstView
	}

	private class func storeAppSceneState(state: AppSceneState) {
		UserDefaults.standard.set(state.rawValue, forKey: "app_scene_state")
		UserDefaults.standard.synchronize()
	}

	// MARK: For debug
	
	func resetState() {
		ScenesManager.storeAppSceneState(state: .introPageFirstView)
	}

	// MARK: Notifications

	@objc private func fontSizeWasChanged() {
		AppSettingsWorker.shared.setUpGlobalFontColorAndSize()
		let rootVc = ScenesManager.shared.window?.rootViewController as! UINavigationController
		// This is a hack, to force it to update font color, size.
		if (rootVc.isNavigationBarHidden) {
			rootVc.isNavigationBarHidden = false
			rootVc.isNavigationBarHidden = true
		} else {
			rootVc.isNavigationBarHidden = true
			rootVc.isNavigationBarHidden = false
		}

		rootVc.popToRootViewController(animated: true)
	}
}



