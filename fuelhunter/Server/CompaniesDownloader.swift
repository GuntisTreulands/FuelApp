//
//  CompaniesDownloader.swift
//  fuelhunter
//
//  Created by Guntis on 09/02/2020.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase

protocol CompaniesDownloaderLogic: class {
	static func isAllowedToDownload() -> Bool
	static func updateLastDownloadTime()
	static func resetLastDownloadTime()
	func work(completionHandler: @escaping () -> Void)
}

class CompaniesDownloader: CompaniesDownloaderLogic {

	static var downloadingState: DownloaderState {
		if DataDownloader.shared.downloaderIsActive {
			return .downloading
		}

		if lastDownloadResult == .none && CompaniesDownloader.isAllowedToDownload() {
			return .downloading
		}
		else
		{
			switch lastDownloadResult {
				case .none:
					return .downloaded
				case .success:
					return .downloaded
				case .timeout:
					return .timeout
				case .serverError:
					return .serverError
				case .parsingError:
					return
						.parsingError
			}
		}
	}

	static var lastDownloadResult: DownloaderLastResult = .none
	
	private func getPreviousSHA() -> String {
		return UserDefaults.standard.string(forKey: "CompaniesSHA") ?? ""
	}

	private func setSHA(sha: String) {
		UserDefaults.standard.set(sha, forKey: "CompaniesSHA")
		UserDefaults.standard.synchronize()
	}



	class func isFirstTime() -> Bool {

		let lastDownloadTimestamp = UserDefaults.standard.double(forKey: "CompaniesDownloaderLastDownloadTimestamp")

		// on first time it probably will be 0
		if lastDownloadTimestamp == 0 {
			return true
		}

		return false
	}


	class func isAllowedToDownload() -> Bool {

		let lastDownloadTimestamp = UserDefaults.standard.double(forKey: "CompaniesDownloaderLastDownloadTimestamp")

		// on first time it probably will be 0
		if lastDownloadTimestamp == 0 {
			return true
		}

		// if it is older than 24 hours
		if lastDownloadTimestamp + 60 * 60 * 24 <= Date().timeIntervalSince1970 {
			// TODO: Send notif, to lock UI for changes.
			return true
		}

		return false
	}

	class func updateLastDownloadTime() {
		UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "CompaniesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}

	class func resetLastDownloadTime() {
		UserDefaults.standard.set(0, forKey: "CompaniesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}


	/*
		Proposal for companies..

		Download it once 24 hours, and once you do,
		if there is some change, it could be presented as a pop up..
		Like, new company available? Pop up that you can now choose also "this source".
		Some company went way (which was selected) ?  Pop up that shows it.
	*/
	func work(completionHandler: @escaping () -> Void) {

		if !CompaniesDownloader.isAllowedToDownload() {
			completionHandler()
			return
		}

		if DataDownloader.shared.downloaderIsActive {
			completionHandler()
			return
		}

		DataDownloader.shared.downloaderIsActive = true

		DispatchQueue.background(background: {
			// do something in background

			var string = "http://www.mocky.io/v2/5ead3d702f00004b001986f1"

			if UserDefaults.standard.integer(forKey: "companyTesting") == 1
			{
				string = "http://www.mocky.io/v2/5ead3d702f00004b001986f1"

				UserDefaults.standard.set(2, forKey: "companyTesting")
				UserDefaults.standard.synchronize()
			}
			else if UserDefaults.standard.integer(forKey: "companyTesting") == 2
			{
				string = "http://www.mocky.io/v2/5ead3dbe2f000067001986f2"

				UserDefaults.standard.set(3, forKey: "companyTesting")
				UserDefaults.standard.synchronize()
			}
			else {

				string = "http://www.mocky.io/v2/5ead3def2f00004d001986f3"

				UserDefaults.standard.set(1, forKey: "companyTesting")
				UserDefaults.standard.synchronize()
			}
//			else if UserDefaults.standard.integer(forKey: "companyTesting") == 10
//			{
//				string = "http://www.mocky.io/v2/5e778ae4330000c24409a009"
//
//				UserDefaults.standard.set(11, forKey: "companyTesting")
//				UserDefaults.standard.synchronize()
//			}
//			else if UserDefaults.standard.integer(forKey: "companyTesting") == 11
//			{
//				string = "http://www.mocky.io/v2/5e778b05330000773a09a00a"
//
//				UserDefaults.standard.set(12, forKey: "companyTesting")
//				UserDefaults.standard.synchronize()
//			}
//			else if UserDefaults.standard.integer(forKey: "companyTesting") == 12
//			{
//				string = "http://www.mocky.io/v2/5e778b28330000290009a00b"
//
//				UserDefaults.standard.set(13, forKey: "companyTesting")
//				UserDefaults.standard.synchronize()
//			}
//			else if UserDefaults.standard.integer(forKey: "companyTesting") == 13
//			{
//				string = "http://www.mocky.io/v2/5e778eda330000290009a014"
//
//				UserDefaults.standard.set(14, forKey: "companyTesting")
//				UserDefaults.standard.synchronize()
//			}
//			else if UserDefaults.standard.integer(forKey: "companyTesting") == 14
//			{
//				string = "http://www.mocky.io/v2/5e7793b03300005d0009a01f"
//
//				UserDefaults.standard.set(15, forKey: "companyTesting")
//				UserDefaults.standard.synchronize()
//			}
//			else
//			{
//				string = "http://www.mocky.io/v2/5e6f8a55330000b38ef07a7a"
//
//				UserDefaults.standard.set(1, forKey: "companyTesting")
//				UserDefaults.standard.synchronize()
//			}

			string = "http://www.mocky.io/v2/5ec3d08e300000e4b039c434"
			
			print("url string \(string)")
			
			let sessionConfig = URLSessionConfiguration.default
			sessionConfig.timeoutIntervalForRequest = 10.0
			sessionConfig.timeoutIntervalForResource = 60.0
			let session = URLSession(configuration: sessionConfig)

			session.dataTask(with: URL(string: string)!) { (data, response, error) -> Void in

				if let httpResponse = response as? HTTPURLResponse {
					print("httpResponse.statusCode \(httpResponse.statusCode)")
				}

				// Check if data was received successfully
				if error == nil && data != nil {

					let sha = NSDataToSha256String.sha256(data: data!)

					if sha == self.getPreviousSHA() {
						print("same old companies data!")
						CompaniesDownloader.updateLastDownloadTime()
						CompaniesDownloader.lastDownloadResult = .success
						DispatchQueue.main.asyncAfter(deadline: .now()) {
							DataDownloader.shared.downloaderIsActive = false
						}
						completionHandler()
						return
					} else {
						print("new companies data!")
					}

					let group = DispatchGroup()

					let task = {
						do {
							/*
								0.) Add (if needed) cheapest
								1.) Disable existing companies
								2.) Update or enable existing companies
								3.) Save
							*/

							let backgroundContext = DataBaseManager.shared.newBackgroundManagedObjectContext()

							let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

//							let cheapestCompany: CompanyEntity!

//							//--- Add (if needed) cheapest
//							fetchRequest.predicate = NSPredicate(format: "isCheapestToggle == %i", true)
//							let companyObjectArray = try backgroundContext.fetch(fetchRequest)
//							if companyObjectArray.isEmpty {
//								cheapestCompany = CompanyEntity.init(context: backgroundContext)
//								cheapestCompany.isCheapestToggle = true
//								cheapestCompany.order = 0
//								cheapestCompany.isEnabled = true
//								cheapestCompany.isHidden = false
//							} else {
//								cheapestCompany = companyObjectArray.first
//							}

							// If we update it here, then at one point, if we change translations, it will be updated.
//							let cheapestCompanyTitle = "company_type_cheapest_title"
//							let cheapestCompanyDescriptionLV = "company_type_cheapest_description".localizedToLV()
//							let cheapestCompanyDescriptionEN = "company_type_cheapest_description".localizedToEN()
//							let cheapestCompanyDescriptionRU = "company_type_cheapest_description".localizedToRU()
//							let cheapestCompanyDescriptionLG = "company_type_cheapest_description".localizedToLG()

//							if cheapestCompany.name != cheapestCompanyTitle {
//								cheapestCompany.name = cheapestCompanyTitle
//							}
//							if cheapestCompany.descriptionLV != cheapestCompanyDescriptionLV {
//								cheapestCompany.descriptionLV = cheapestCompanyDescriptionLV
//							}
//							if cheapestCompany.descriptionEN != cheapestCompanyDescriptionEN {
//								cheapestCompany.descriptionEN = cheapestCompanyDescriptionEN
//							}
//							if cheapestCompany.descriptionRU != cheapestCompanyDescriptionRU {
//								cheapestCompany.descriptionRU = cheapestCompanyDescriptionRU
//							}
//							if cheapestCompany.descriptionLG != cheapestCompanyDescriptionLG {
//								cheapestCompany.descriptionLG = cheapestCompanyDescriptionLG
//							}
							//===


							//--- Fetch old companies
//							fetchRequest.predicate = NSPredicate(format: "isCheapestToggle == %i", false)
							var oldCompanies = try backgroundContext.fetch(fetchRequest)
							let oldCompanyCount = oldCompanies.count
							print("oldCompanyCount \(oldCompanyCount)")
							//=== Fetch old companies

							if let decodedResults = try? JSONDecoder().decode(CompanyRequestCodable.self, from: data!) {

								let key = UIScreen.main.scale == 3 ? "3x" : "2x"

//								var atLeastOneNewCompanyIsEnabled = false

//								var atLeastOneNewCompanyIsAdded = false

								//--- Update or enable existing companies
								for company in decodedResults.companies {

									//--- Company
									let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
									
									fetchRequest.predicate = NSPredicate(format: "name == %@", company.name)
									let companyObjectArray = try backgroundContext.fetch(fetchRequest)

									var companyObject: CompanyEntity!
									var companyMetaDataObject: CompanyMetaDataEntity!
									if companyObjectArray.isEmpty {
										companyObject = CompanyEntity.init(context: backgroundContext)
										companyObject.name = company.name
										companyObject.isEnabled = true

										companyMetaDataObject = CompanyMetaDataEntity.init(context: backgroundContext)
										companyMetaDataObject.company = companyObject

									} else {
										companyObject = companyObjectArray.first

										// Remove from old companies list, as those will be disabled.
										if oldCompanies.contains(companyObject) {
											oldCompanies.removeAll(where: {$0 == companyObject})
										}
									}

//									if companyObject.isEnabled {
//										atLeastOneNewCompanyIsEnabled = true
//									}
//
//									atLeastOneNewCompanyIsAdded = true

									// If downloaded company.hidden is different than saved state
									// Then we change state, but also enable pop up value.
									if companyObject.isHidden != company.hidden {
										companyObject.isHidden = company.hidden

										// So, not to happen on first time, when we had no companies
										if oldCompanyCount != 0 {
											if companyObject.shouldPopUpToUser == false {
												// Only if company is visible, or hidden+enabled we pop up.
												if companyObject.isHidden == false
													|| (companyObject.isHidden == true && companyObject.isEnabled == true)
												{
													companyObject.shouldPopUpToUser = true
												}
											}
										}
									}

//									if let description = company.description {
//										if companyObject.descriptionLV != description["lv"] {
//											companyObject.descriptionLV = description["lv"]
//										}
//
//										if companyObject.descriptionRU != description["ru"] {
//											companyObject.descriptionRU = description["ru"]
//										}
//
//										if companyObject.descriptionEN != description["en"] {
//											companyObject.descriptionEN = description["en"]
//										}
//
//										if companyObject.descriptionLG != description["lg"] {
//											companyObject.descriptionLG = description["lg"]
//										}
//									}

									if let homepage = company.homepage {
										if companyObject.homePage != homepage {
											companyObject.homePage = homepage
										}
									}

									if companyObject.order != Int16(company.order) {
										companyObject.order = Int16(company.order)
									}

									if let logo = company.logo, companyObject.logoName != logo[key] {
										companyObject.logoName = logo[key]
									}

									if let largeLogo = company.largeLogo, companyObject.largeLogoName != largeLogo[key] {
										companyObject.largeLogoName = largeLogo[key]
									}

									if let mapLogo = company.mapLogo, companyObject.mapLogoName != mapLogo[key] {
										companyObject.mapLogoName = mapLogo[key]
									}

									if let mapGrayLogo = company.mapGrayLogo, companyObject.mapGrayLogoName != mapGrayLogo[key] {
										companyObject.mapGrayLogoName = mapGrayLogo[key]
									}
									//===
								}

//								// We have possibly new company set..
//								// If cheapest company is disabled, we need to enable it, if no other is enabled
//								if cheapestCompany.isEnabled == false && atLeastOneNewCompanyIsEnabled == false {
//									cheapestCompany.isEnabled = true
//								}
//
////								 If there are no companies, then we don't show this one either.
//								if cheapestCompany.isHidden != !atLeastOneNewCompanyIsAdded {
//									cheapestCompany.isHidden = !atLeastOneNewCompanyIsAdded
//								}

								//--- oldCompanies should contain only those, that were not downloaded anymore.
								for oldCompany in oldCompanies {
									oldCompany.isHidden = true

									// So, not to happen on first time, when we had no companies
									if oldCompanyCount != 0 {
										if oldCompany.shouldPopUpToUser == false {
											// Only if old company was enabled, we pop up.
											if oldCompany.isEnabled == true {
												oldCompany.shouldPopUpToUser = true
											}
										}
									}
								}
								//===

								DataBaseManager.shared.saveBackgroundContext(backgroundContext: backgroundContext)
								self.setSHA(sha: sha)

								print("Companies - Sucess downloading and parsing!.")
								CompaniesDownloader.updateLastDownloadTime()
								CompaniesDownloader.lastDownloadResult = .success
							} else {
								CompaniesDownloader.resetLastDownloadTime()
								CompaniesDownloader.lastDownloadResult = .parsingError
							}
						} catch let error {
							// Something went wrong
							print("Companies - Something went wrong. Reseting. \(error)")
							Crashlytics.crashlytics().record(error: error)
//							Analytics.logEvent("downloading - companies", parameters: ["Error": "error \(error.localizedDescription)"])
							CompaniesDownloader.resetLastDownloadTime()
							CompaniesDownloader.lastDownloadResult = .parsingError
						}

						print("status was called! Main thread = \(Thread.current.isMainThread) ");
						group.leave()
					}

					group.enter()
					
					DataBaseManager.shared.addATask(action: task)

					print("about to wait!")

					group.wait()

					print("Companies FINALIZEE!!!!!")
				} else {
					print("Companies - Received error OR no data. \(error ?? "" as! Error)")
					CompaniesDownloader.resetLastDownloadTime()

					if let error = error {

						print("(error as NSError).code \((error as NSError).code)")

						if (error as NSError).code == -1009 { // No internet connection
							CompaniesDownloader.lastDownloadResult = .serverError
						} else if (error as NSError).code == -1001 { // Bad connection - timeout
							CompaniesDownloader.lastDownloadResult = .timeout
						} else {
							CompaniesDownloader.lastDownloadResult = .serverError
						}
					} else {
						CompaniesDownloader.lastDownloadResult = .serverError
					}

					if let httpResponse = response as? HTTPURLResponse {
						print("Companies - httpResponse.statusCode \(httpResponse.statusCode)")
					}
				}

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
					// when background job finished, do something in main thread
					DataDownloader.shared.downloaderIsActive = false

					completionHandler()
				}

			}.resume()

		}, completion:{
		})
	}
}
