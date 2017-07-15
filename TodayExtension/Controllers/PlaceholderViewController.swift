//
//  PlaceholderViewController.swift
//  MensaplanDesktopTodayExtension
//
//  Created by Nick Podratz on 11.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa

class PlaceholderViewController: NSViewController {

    @IBOutlet weak var placeholderTextField: NSTextField!
    
    override var representedObject: Any? {
        didSet {
            if isViewLoaded {
                self.setup()
            }
        }
    }

    override var nibName: String? {
        return "PlaceholderViewController"
    }
    
    
    // MARK: - Life Cycle

    override func loadView() {
        super.loadView()
        setup()
    }
    
    func setup() {
        guard let value = self.representedObject as? String else { return }
        placeholderTextField.stringValue = value
    }
    
    
}

