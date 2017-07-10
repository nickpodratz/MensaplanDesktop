//
//  MenuViewController.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 21.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa

private let cellIdentifier = "MealCell"

class MenuViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    var meals: [Meal] = []
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layout()
        tableView.reloadData()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        viewDidAppear()
        tableView.reloadData()
    }
    
    
    // MARK: - Table View
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? MealCell {
            let meal = meals[row]
            cell.categoryTextField.stringValue = meal.locationCategoryString
            cell.titleTextField.stringValue = meal.title
            cell.priceTextField.stringValue = meal.priceString ?? ""
            cell.updateConstraints()
            return cell
        }
        return nil
    }
    
    func tableViewColumnDidResize() {
        let allIndices = IndexSet(integersIn: 0..<tableView.numberOfRows)
        tableView.noteHeightOfRows(withIndexesChanged: allIndices)
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let cellView = tableView.make(withIdentifier: cellIdentifier, owner: nil) as! MealCell
        cellView.updateConstraints()
        cellView.needsLayout = true
        return cellView.fittingSize.height
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return meals.count
    }
    

}
