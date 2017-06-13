//
//  RoundedView.swift
//  Connect
//
//  Created by Nick Podratz on 21.12.15.
//  Copyright © 2015 Nick Podratz. All rights reserved.
//

import Cocoa

@IBDesignable class RoundedView: NSView {
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet{
            self.layer?.cornerRadius = cornerRadius
            self.layer?.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer?.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: NSColor = NSColor.clear {
        didSet{
            self.layer?.borderColor = borderColor.cgColor
        }
    }
    
    
}


@IBDesignable class RoundedImageView: NSImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet{
            self.layer?.cornerRadius = cornerRadius
            self.layer?.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer?.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: NSColor = NSColor.clear {
        didSet{
            self.layer?.borderColor = borderColor.cgColor
        }
    }
    
    
}


@IBDesignable class RoundedButton: NSButton {
    
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet{
            self.layer?.cornerRadius = cornerRadius
            self.layer?.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            self.layer?.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: NSColor = NSColor.clear {
        didSet{
            self.layer?.borderColor = borderColor.cgColor
        }
    }
    
    
}

