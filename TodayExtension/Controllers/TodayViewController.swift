//
//  TodayViewController.swift
//  MensaplanTodayExtension
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

    // MARK: - NSViewController
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        listViewController.delegate = self
        widgetPerformUpdate() {_ in }
    }
    
    // MARK: - NCWidgetProviding
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateWidgetContents() { result in
            completionHandler(result)
            self.updateView(result)
        }
    }
    
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
    
    func updateWidgetContents(completionHandler: ((NCUpdateResult) -> Void)? = nil) {
        listViewController.contents = [""]
        progressIndicator.startAnimation(self)

        provider.request(.getMeals) { response in
            defer { self.progressIndicator.stopAnimation(self) }
            
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
    
    func updateView(_ result: NCUpdateResult) {
        listViewController.contents = {
            switch result {
            case .failed: return ["⁉️  Ein Fehler ist aufgetreten."]
            case .noData: return ["∅  Keine Einträge vorhanden."]
            case .newData:
                guard let mealMenu = mealMenu else {
                    return ["⁉️  Ein Fehler ist aufgetreten."]
                }
                guard !mealMenu.today.isEmpty else {
                    return ["👨🏻‍🍳  Keine Enträge für heute."]
                }
                return mealMenu.today
            }
        }()
    }

}

