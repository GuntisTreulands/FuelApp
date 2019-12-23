//
//  FontChangeView.swift
//  fuelhunter
//
//  Created by Guntis on 08/12/2019.
//  Copyright © 2019 myEmerg. All rights reserved.
//

import UIKit

protocol FontChangeViewNotifications {
	func fontSizeWasChanged()
}

class FontChangeView: UIView {

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)

		NotificationCenter.default.addObserver(self, selector: #selector(fontSizeWasChanged),
    		name: .fontSizeWasChanged, object: nil)
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		NotificationCenter.default.addObserver(self, selector: #selector(fontSizeWasChanged),
    		name: .fontSizeWasChanged, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self, name: .fontSizeWasChanged, object: nil)
	}

	// MARK: FontChangeTableViewCellNotifications
	@objc func fontSizeWasChanged() {
		// override
	}
}
