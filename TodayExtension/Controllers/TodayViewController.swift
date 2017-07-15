//
//  TodayViewController.swift
//  MensaplanDesktopTodayExtension
//
//  Created by Nick Podratz on 10.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa
import NotificationCenter
import Moya

class TodayViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate {
    
    @IBOutlet var listViewController: NCWidgetListViewController!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    var mealMenu: Menu?
    
    var provider: MoyaProvider<BackendService> = {
        #if DEBUG
            return MoyaProvider<BackendService>(stubClosure: MoyaProvider.delayedStub(1))
        #else
            return MoyaProvider<BackendService>()
        #endif
    }()
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewController.delegate = self
        updateWidgetContent(completionHandler: updateView)
    }
        
    
    // MARK: - NCWidgetProviding
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: EdgeInsets) -> EdgeInsets {
        var newInsets = defaultMarginInset
        newInsets.left = 0
        return newInsets
    }
    
    
    // MARK: - NCWidgetListViewDelegate
    
    func widgetList(_ list: NCWidgetListViewController, viewControllerForRow row: Int) -> NSViewController {
        switch listViewController.contents[row] {
        case let meal as Meal:
            let listVC = ListRowViewController(nibName: "ListRowViewController", bundle: nil)!
            listVC.representedObject = meal
            return listVC
        case let string as String:
            let placeholderVC = PlaceholderViewController(nibName: "PlaceholderViewController", bundle: nil)!
            placeholderVC.representedObject = string
            return placeholderVC
        default: return NSViewController()
        }
    }
    
    func updateWidgetContent(completionHandler: ((NCUpdateResult) -> Void)? = nil) {
        provider.request(.getMeals) { response in
            switch response {
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?(.failed)
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
            }
        }
    }
    
    /// Display today's menu or an error message if it cannot be displayed
    func updateView(_ result: NCUpdateResult) {
        listViewController.contents = {
            switch (result, mealMenu) {
            case (.noData, nil):
                return ["∅  Keine Einträge vorhanden."]
            case (.failed, nil),
                 (.newData, nil):
                return ["⁉️  Ein Fehler ist aufgetreten."]
            case let (.newData, menu?) where menu.today.isEmpty:
                return ["👨🏻‍🍳  Keine Enträge für heute."]
            case let (_, menu?):
                return  menu.today
            }
        }()
    }

}

