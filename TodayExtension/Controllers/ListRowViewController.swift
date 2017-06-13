//
//  ListRowViewController.swift
//  MensaplanTodayExtension
//
//  Created by Nick Podratz on 10.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa

class ListRowViewController: NSViewController {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var categoryTextField: NSTextField!
    @IBOutlet weak var priceTextField: NSTextField!
    @IBOutlet weak var priceTextFieldUpConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceTextFieldHeightConstraint: NSLayoutConstraint!
    
    override var representedObject: Any? {
        didSet {
            if isViewLoaded {
                self.setup()
            }
        }
    }
    
    override var nibName: String? {
        return "ListRowViewController"
    }

    override func loadView() {
        super.loadView()
        setup()
    }
    
    func setup() {
        guard let meal = self.representedObject as? Meal else { return }
        
        titleTextField.stringValue = meal.title
        categoryTextField.stringValue = meal.locationCategoryString
        if let priceString = meal.priceString {
            priceTextField.stringValue = priceString
        } else {
            priceTextFieldUpConstraint.constant = 0
            priceTextFieldHeightConstraint.constant = 0
        }
    }
    
    
}

