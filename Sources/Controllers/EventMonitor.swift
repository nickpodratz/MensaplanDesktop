//
//  EventMonitor.swift
//  MensaplanDesktop
//
//  Created by Nick Podratz on 19.06.17.
//  Copyright © 2017 Nick Podratz. All rights reserved.
//

import Cocoa

public class EventMonitor {
    
    private var monitor: AnyObject?
    private let mask: NSEventMask
    private let handler: (NSEvent?) -> ()
    
    var isEnabled: Bool {
        willSet {
            newValue ? enable() : disable()
        }
    }

    init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
        isEnabled = true
    }
    
    deinit {
        isEnabled = false
    }
    
    
    // MARK: Helpers
    
    private func enable() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
    }
    
    private func disable() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
    
    
}
