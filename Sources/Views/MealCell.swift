//
//  MealCell.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 19.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa

class MealCell: NSTableCellView {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var categoryTextField: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var priceTextFieldUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceTextFieldHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Custom Layout
    
    override func updateConstraints() {
        super.updateConstraints()
        if priceTextField.stringValue.isEmpty {
            priceTextFieldUpConstraint.constant = 0
            priceTextFieldHeightConstraint.constant = 0
        }
    }
    
    
}

