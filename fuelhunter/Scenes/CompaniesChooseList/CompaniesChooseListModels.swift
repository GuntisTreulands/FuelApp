//
//  CompaniesChooseListModels.swift
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

enum CompaniesChooseList {
  	// MARK: Use cases

	enum CompanyCells {
		struct Request {
		}
		struct Response {
		}
		struct ViewModel {
			struct DisplayedCompanyCellItem: Equatable {
				var title: String
				var description: String
				var imageName: String
				var toggleStatus: Bool = false
			}
			var displayedCompanyCellItems: [DisplayedCompanyCellItem]
		}
  	}
}
