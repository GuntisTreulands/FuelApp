//
//  FuelListCell.swift
//  fuelhunter
//
//  Created by Guntis on 09/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SDWebImage

protocol FuelListCellDisplayLogic {
    func setAsCellType(cellType: CellBackgroundType)
}

class FuelListCell: FontChangeTableViewCell, FuelListCellDisplayLogic {

	public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var addressesLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!

	var bgViewBottomAnchorConstraint: NSLayoutConstraint!
	var bgViewTopAnchorConstraint: NSLayoutConstraint!
	var iconBottomConstraint: NSLayoutConstraint!

	// MARK: View lifecycle
	
	override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressesLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bgViewBottomAnchorConstraint.isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
		bgViewTopAnchorConstraint.isActive = true

		iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 11).isActive = true
		iconImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true
		iconBottomConstraint = iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -11)
		iconBottomConstraint.priority = .defaultHigh
		iconBottomConstraint.isActive = true

		titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6).isActive = true

		addressesLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		addressesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		addressesLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -9).isActive = true

		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 6).isActive = true
		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: addressesLabel.rightAnchor, constant: 6).isActive = true
		priceLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		priceLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
		priceLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

		//TODO: Calculate width of normal price, and provide it as minimum
		priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true

		updateFonts()
    }

	// MARK: Functions

	private func updateFonts() {
		titleLabel.font = Font(.medium, size: .size2).font
		priceLabel.font = Font(.bold, size: .size1).font
		addressesLabel.font = Font(.normal, size: .size4).font
	}

	override func fontSizeWasChanged() {
		updateFonts()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	// MARK: FuelListCellDisplayLogic

	func setAsCellType(cellType: CellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_top")
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_bottom")
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_middle")
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_single")
			default:
				break
		}
	}
}
