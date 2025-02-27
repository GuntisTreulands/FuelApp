//
//  FontChangeView.swift
//  fuelhunter
//
//  Created by Guntis on 08/12/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

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

	// MARK: Functions

	@objc func fontSizeWasChanged() {
		// override
	}
}

class FontChangeHeaderFooterView: UITableViewHeaderFooterView {

	// MARK: View lifecycle

	override func awakeFromNib() {
	super.awakeFromNib()

		NotificationCenter.default.addObserver(self, selector: #selector(fontSizeWasChanged),
    		name: .fontSizeWasChanged, object: nil)
  	}

	deinit {
		NotificationCenter.default.removeObserver(self, name: .fontSizeWasChanged, object: nil)
	}

	// MARK: Functions

	@objc func fontSizeWasChanged() {
		// override
	}
}
