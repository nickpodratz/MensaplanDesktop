//
//  ListRowViewController.swift
//  MensaplanTodayExtension
//
//  Created by Nick Podratz on 10.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa

class ListRowViewController: NSViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        guard let meal = self.representedObject as? Meal else { return }
        guard let view = self.view as? MealCell else { return }
        
        view.titleTextField.stringValue = meal.title
        view.categoryTextField.stringValue = meal.locationCategoryString
        view.priceTextField.stringValue = meal.priceString ?? ""
    }
    
    
}

