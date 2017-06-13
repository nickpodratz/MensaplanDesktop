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

    var provider: MoyaProvider<BackendService>!
    
    @IBOutlet var listViewController: NCWidgetListViewController!
    
    // MARK: - NSViewController
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
            provider = MoyaProvider<BackendService>(stubClosure: MoyaProvider.immediatelyStub)
        #else
            provider = MoyaProvider<BackendService>()
        #endif
    }
    
    override func viewWillAppear() {
        listViewController.delegate = self
        updateWidgetContents()
    }
    
    // MARK: - NCWidgetProviding
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        updateWidgetContents(completionHandler: completionHandler)
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
        provider.request(.getMeals) { response in
            switch response {
            case .success(let response):
                guard !response.data.isEmpty else {
                    self.listViewController.contents = ["∅  Keine Einträge vorhanden."]
                    completionHandler?(.noData)
                    return
                }
                let mealsWithDates = Meal.array(fromResponse: response).filter{$0.date != nil}
                let mealsOfSigleDay: [Meal]
                #if DEBUG // Instead of today's menu, the meals of the nearest day from now from the sample response are shown
                    let nextMealDay = mealsWithDates.reduce(mealsWithDates.first?.date, { (minDate, meal) in return min(minDate!, meal.date!) })
                    mealsOfSigleDay = mealsWithDates.filter{ $0.date == nextMealDay }
                #else
                    mealsOfSigleDay = mealsWithDates.filter{ $0.isToday }
                #endif
                self.listViewController.contents = !mealsOfSigleDay.isEmpty ? mealsOfSigleDay : ["👨🏻‍🍳  Keine Enträge für heute."]
                completionHandler?(.newData)

            case .failure(let error):
                print(error.localizedDescription)
                self.listViewController.contents = ["⁉️  Ein Fehler ist aufgetreten."]
                completionHandler?(.failed)
            }
        }
    }
    

}

