//
//  PopoverViewController.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 19.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa
import NotificationCenter
import Moya


private let cellIdentifier = "MealCell"

class PopoverViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var clickGestureRecognizer: NSClickGestureRecognizer!
    
    var mealMenu: Menu?
    var provider: MoyaProvider<BackendService>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
            provider = MoyaProvider<BackendService>(stubClosure: MoyaProvider.delayedStub(1))
        #else
            provider = MoyaProvider<BackendService>()
        #endif
        tableView.delegate = self
        tableView.dataSource = self
        statusLabel.stringValue = ""
        updateContents()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let menu = mealMenu else { return nil }
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? MealCell {
            cell.categoryTextField.stringValue = menu.today[row].locationCategoryString
            cell.titleTextField.stringValue = menu.today[row].title
            cell.priceTextField.stringValue = menu.today[row].priceString ?? ""
            cell.layout()
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
        
        cellView.bounds.size.height = tableView.bounds.size.height
        cellView.needsLayout = true
        cellView.updateConstraints()
        cellView.layoutSubtreeIfNeeded()
        
        let height = cellView.fittingSize.height

        // Make sure at least the table view height is returned
        return height > tableView.rowHeight ? height : tableView.rowHeight
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return mealMenu?.today.count ?? 0
    }
    
    @IBAction func clickedView(_ sender: NSClickGestureRecognizer) {
        updateContents()
    }
    
    func updateContents(completionHandler: ((NCUpdateResult) -> Void)? = nil) {
        mealMenu = nil
        tableView.reloadData()
        progressIndicator.startAnimation(self)
        clickGestureRecognizer.isEnabled = false
        updateStatusLabel(nil)

        fetchMenu() { result in
            defer { completionHandler?(result) }
            self.progressIndicator.stopAnimation(self)
            switch result {
            case .failed:
                self.updateStatusLabel("⁉️  Ein Fehler ist aufgetreten.")
                self.clickGestureRecognizer.isEnabled = true
            case .noData:
                self.updateStatusLabel("∅  Keine Einträge vorhanden.")
                self.clickGestureRecognizer.isEnabled = true
            case .newData where self.mealMenu != nil && self.mealMenu!.today.isEmpty:
                self.updateStatusLabel("👨🏻‍🍳  Keine Enträge für heute.")
                self.clickGestureRecognizer.isEnabled = true
            case .newData:
                if let meal = self.mealMenu?.today.first, let date = meal.date {
                    if Calendar.current.isDateInToday(date) {
                        self.titleLabel.stringValue = "Heute"
                    } else if Calendar.current.isDateInTomorrow(date) {
                        self.titleLabel.stringValue = "Morgen"
                    } else {
                        self.titleLabel.stringValue = date.germanFormatted
                    }
                }
            }
            self.tableView.reloadData()
            self.tableView.layout()
            self.tableView.reloadData()
        }
    }
    
    private func fetchMenu(completionHandler: ((NCUpdateResult) -> Void)? = nil) {
        provider.request(.getMeals) { result in
            switch result {
            case .success(let response):
                guard !response.data.isEmpty else {
                    completionHandler?(.noData)
                    return
                }
                guard let menu = Menu(fromResponse: response) else {
                    completionHandler?(.failed)
                    return
                }
                self.mealMenu = menu
                completionHandler?(.newData)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?(.failed)
            }
        }
    }
    
    private func updateStatusLabel(_ string: String?) {
        statusLabel.isHidden = (string == nil)
        if let string = string {
            self.statusLabel.stringValue = string
        }
    }
    
    
}

