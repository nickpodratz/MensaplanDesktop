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

class PopoverViewController: FLOPageViewController {
    
    @IBOutlet weak var quitNavigationButton: NSButton!
    @IBOutlet weak var leftNavigationButton: NSButton!
    @IBOutlet weak var rightNavigationButton: NSButton!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var clickGestureRecognizer: NSClickGestureRecognizer!
    
    var mealMenu: Menu?
    var provider: MoyaProvider<BackendService> = {
        #if DEBUG
            return MoyaProvider<BackendService>(stubClosure: MoyaProvider.delayedStub(1))
        #else
            return MoyaProvider<BackendService>()
        #endif
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationButtons()
        reloadData()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        reloadData(clearsOldDataOnStart: false)
    }
    
    
    // MARK: - Actions
    
    @IBAction func handleViewClicked(_ sender: NSClickGestureRecognizer) {
        reloadData()
    }
    
    @IBAction func handleNavigationButtonClicked(_ sender: NSButton) {
        switch sender.tag {
        case -1: pageController.navigateBack(nil)
        case +1: pageController.navigateForward(nil)
        default: break
        }
    }
    
    @IBAction func handleQuitClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    
    // MARK: - Networking
    
    func reloadData(clearsOldDataOnStart isClearing: Bool = true) {
        if isClearing {
            progressIndicator.startAnimation(self)
            updateStatusLabel(contentState: nil)
        }
        clickGestureRecognizer.isEnabled = false

        fetchMenu() { result in
            if isClearing || result == .newData {
                self.progressIndicator.stopAnimation(self)
                self.updateStatusLabel(contentState: result)
            }
            if result != .newData { // enable reload only if data is invalid
                self.clickGestureRecognizer.isEnabled = true
            }
            self.updateContainerView()
            self.setupTableViewControllers()
        }
    }
    
    private func fetchMenu(completionHandler: ((NCUpdateResult) -> Void)? = nil) {
        provider.request(.getMeals) { result in
            switch result {
            case .success(let response):
                self.mealMenu = Menu(fromResponse: response)
                if response.data.isEmpty {
                    completionHandler?(.noData)
                } else if self.mealMenu == nil {
                    completionHandler?(.failed)
                } else {
                    completionHandler?(.newData)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler?(.failed)
            }
        }
    }
    
    
    // MARK: - Layouting
    
    private func setupTableViewControllers() {
        guard let menu = mealMenu else { return }
        
        let storyboard = NSStoryboard.init(name: "Main", bundle: nil)
        let identifiers = [String](repeating: "MenuViewController", count: menu.dates.count)
        loadViewControllers(identifiers, from: storyboard)
        
        guard let menuViewControllers = viewControllers as? [MenuViewController] else { return }
        for (i, viewController) in menuViewControllers.enumerated() {
            let date = menu.dates[i]
            viewController.meals = menu.mealsByDate[date] ?? []
        }
        pageController.selectedViewController?.viewWillAppear()
        pageController.selectedViewController?.viewDidLoad()
        for vc in viewControllers {
            vc.loadView()
            vc.view.layoutSubtreeIfNeeded()
        }
    }
    
    private func updateContainerView() {
        updateTitleLabel()
        updateNavigationButtons()
    }

    private func updateTitleLabel() {
        let index = pageController.selectedIndex
        let date = mealMenu?.dates[index]

        titleLabel.stringValue = {
            switch date {
            case let date? where Calendar.current.isDateInToday(date):    return "Heute"
            case let date? where Calendar.current.isDateInTomorrow(date): return "Morgen"
            case let date?:                                               return date.germanWeekdayFormatted
            default:                                                      return "Mensaplan"
            }
        }()
    }
    
    private func updateNavigationButtons() {
        defer { quitNavigationButton.isHidden = !rightNavigationButton.isHidden }
        guard let menu = mealMenu else {
            leftNavigationButton.isHidden = true
            rightNavigationButton.isHidden = true
            return
        }
        leftNavigationButton.isHidden = !(pageController.selectedIndex > 0)
        rightNavigationButton.isHidden = !(pageController.selectedIndex < menu.dates.count-1)
        quitNavigationButton.isHidden = (pageController.selectedIndex < menu.dates.count-1)
    }
    
    private func updateStatusLabel(contentState: NCUpdateResult?) {
        statusLabel.stringValue = {
            switch (contentState, mealMenu) {
            case (.failed?, _):
                return "⁉️  Ein Fehler ist aufgetreten."
            case (.noData?, _):
                return "∅  Keine Einträge vorhanden."
            case (.newData?, let menu?) where menu.comingNext.isEmpty:
                return "👨🏻‍🍳  Keine Enträge für heute."
            default:
                return ""
            }
        }()
    }

    
    // MARK: - Page Controller
    
    override func pageController(_ pageController: NSPageController, didTransitionTo object: Any) {
        super.pageController(pageController, didTransitionTo: object)
        updateContainerView()
    }
    

}

