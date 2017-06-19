//
//  PopoverViewController.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 19.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa

private let cellIdentifier = "MealCell"

class PopoverViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? MealCell {
            cell.categoryTextField.stringValue = "Mensa: Gericht 1"
            cell.titleTextField.stringValue = "Spaghetti aglio e olio"
            cell.priceTextField.stringValue = "2,90 €"
            return cell
        }
        return nil
    }
    
    func tableViewColumnDidResize(_ notification: Notification) {
        let allIndices = IndexSet(integersIn: 0..<tableView.numberOfRows)
        tableView.noteHeightOfRows(withIndexesChanged: allIndices)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let cellView = tableView.make(withIdentifier: cellIdentifier, owner: nil) as! MealCell
        
        cellView.bounds.size.height = tableView.bounds.size.height
        cellView.needsLayout = true
        cellView.layoutSubtreeIfNeeded()
        
        let height = cellView.fittingSize.height

        // Make sure at least the table view height is returned
        return height > tableView.rowHeight ? height : tableView.rowHeight
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 7
    }
    
    
}

