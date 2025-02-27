//
//  IntroGPSSetUpLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol IntroGPSSetUpLayoutViewLogic {
	func giveAccessButtonPressed()
	func laterButtonPressed()
}

class IntroGPSSetUpLayoutView: FontChangeView {

	weak var controller: IntroGPSSetUpViewController? 

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var mapAnimationView: MapAnimationView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var giveAccessButton: UIButton!
	@IBOutlet weak var laterButton: UIButton!

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("IntroGPSSetUpLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		mapAnimationView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		giveAccessButton.translatesAutoresizingMaskIntoConstraints = false
		laterButton.translatesAutoresizingMaskIntoConstraints = false

		let space1 = UILayoutGuide()
		self.addLayoutGuide(space1)
		let space1HeightAnchor = space1.heightAnchor.constraint(equalToConstant: 120)
		space1HeightAnchor.priority = .init(rawValue: 500)
		space1HeightAnchor.isActive = true

		let space2 = UILayoutGuide()
		self.addLayoutGuide(space2)
		let space2HeightAnchor = space2.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1)
		space2HeightAnchor.priority = .init(rawValue: 500)
		space2HeightAnchor.isActive = true

		let space3 = UILayoutGuide()
		self.addLayoutGuide(space3)
		let space3HeightAnchor = space3.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1.25)
		space3HeightAnchor.priority = .init(rawValue: 500)
		space3HeightAnchor.isActive = true

		let space4 = UILayoutGuide()
		self.addLayoutGuide(space4)
		let space4HeightAnchor = space4.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1.25)
		space4HeightAnchor.priority = .init(rawValue: 500)
		space4HeightAnchor.isActive = true

		let space5 = UILayoutGuide()
		self.addLayoutGuide(space5)
		let space5HeightAnchor = space5.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 3)
		space5HeightAnchor.priority = .init(rawValue: 500)
		space5HeightAnchor.isActive = true

		let space6 = UILayoutGuide()
		self.addLayoutGuide(space6)
		let space6HeightAnchor = space6.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 2)
		space6HeightAnchor.priority = .init(rawValue: 1)
		space6HeightAnchor.isActive = true

		let space7 = UILayoutGuide()
		self.addLayoutGuide(space7)
		let space7HeightAnchor = space7.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1.25)
		space7HeightAnchor.priority = .init(rawValue: 500)
		space7HeightAnchor.isActive = true
		
		space1.topAnchor.constraint(equalTo: topAnchor).isActive = true
		mapAnimationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true		
		mapAnimationView.topAnchor.constraint(equalTo: space1.bottomAnchor).isActive = true

		space2.topAnchor.constraint(equalTo: mapAnimationView.bottomAnchor).isActive = true

		titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		titleLabel.topAnchor.constraint(equalTo: space2.bottomAnchor).isActive = true

		space3.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true

		separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		separatorView.topAnchor.constraint(equalTo: space3.bottomAnchor).isActive = true
		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

		space4.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true

		descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: space4.bottomAnchor).isActive = true

		space5.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
		space6.topAnchor.constraint(equalTo: space5.bottomAnchor).isActive = true

		giveAccessButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		giveAccessButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		giveAccessButton.topAnchor.constraint(equalTo: space6.bottomAnchor).isActive = true

		space7.topAnchor.constraint(equalTo: giveAccessButton.bottomAnchor).isActive = true

		laterButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		laterButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		laterButton.topAnchor.constraint(equalTo: space7.bottomAnchor).isActive = true
		laterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
		
		titleLabel.text = "intro_location_title".localized()
		descriptionLabel.text = "intro_location_description".localized()
		giveAccessButton.setTitle("give_access_button_title".localized(), for: .normal)
		laterButton.setTitle("later_button_title".localized(), for: .normal)

		giveAccessButton.addTarget(self, action:NSSelectorFromString("giveAccessButtonPressed"), for: .touchUpInside)
		laterButton.addTarget(self, action:NSSelectorFromString("laterButtonPressed"), for: .touchUpInside)

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		mapAnimationView.startAnimating()

  	 	updateFonts()
    }

  	// MARK: Functions

	private func updateFonts() {
		titleLabel.font = Font(.normal, size: .size0).font
		descriptionLabel.font = Font(.normal, size: .size2).font
		giveAccessButton.titleLabel?.font = Font(.medium, size: .size2).font
		laterButton.titleLabel?.font = Font(.medium, size: .size2).font
	}

  	@objc private func giveAccessButtonPressed() {
		controller?.giveAccessButtonPressed()
  	}

  	@objc private func laterButtonPressed() {
		controller?.laterButtonPressed()
  	}

  	override func fontSizeWasChanged() {
		updateFonts()
	}
}
