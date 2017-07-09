//
//  BadgeLabel.swift
//  Tapasi
//
//  Created by Nick Podratz on 11.08.16.
//  Copyright © 2016 Nick Podratz. All rights reserved.
//

import Cocoa

/**
    `BadgeLabel` is a `UILabel` subclass that immitates Apple's homescreen notification-badge.
    You can customize `offset` (default x: 6, y: 2) to change the padding around the text.
    The corners are rounded and the text is centered by default.
*/
@IBDesignable class BadgeTextField: NSTextField {
    
    // A convenience property based on the designable `offset` property
    var edgeInsets: EdgeInsets {
        return EdgeInsets(
            top: offset.y,
            left: offset.x,
            bottom: offset.y,
            right: offset.x
        )
    }

    
    // MARK: - Designable Properties
    
    /// The padding around the displayed text
    @IBInspectable var offset: CGPoint = CGPoint(x: 6, y: 2) {
        didSet {
            layout()
        }
    }
    
    
    // MARK: - Initialization
    
    fileprivate func commonInit() {
        alignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    
    // MARK: - Custom Drawing

    override func layout() {
        super.layout()
        layer?.cornerRadius = min(bounds.height, bounds.width) / 2
        layer?.masksToBounds = layer?.cornerRadius ?? 1 > 0
        layoutSubtreeIfNeeded()
        needsLayout = true
    }
    
    override func draw(withExpansionFrame contentFrame: NSRect, in view: NSView) {
        let width = contentFrame.width - (edgeInsets.right + edgeInsets.left)
        let height = contentFrame.height - (edgeInsets.top + edgeInsets.bottom)
        let rectWithInsets: CGRect
        
        if width < height {  // Make sure badge is at least a circle
            rectWithInsets = CGRect(
                x: contentFrame.origin.x,
                y: contentFrame.origin.y,
                width: contentFrame.width,
                height: contentFrame.height)
        } else {
            rectWithInsets = CGRect(
                x: contentFrame.origin.x + edgeInsets.left,
                y: contentFrame.origin.y + edgeInsets.top,
                width: width,
                height: height)
        }
        
        super.draw(withExpansionFrame: rectWithInsets, in: view)
    }
    
    override var intrinsicContentSize : CGSize {
        let size = super.intrinsicContentSize
        let intrinsicWidth = size.width + (edgeInsets.left + edgeInsets.right)
        let intrinsicHeight = size.height + (edgeInsets.top + edgeInsets.bottom)
        
        if intrinsicWidth < intrinsicHeight {  // Make sure badge is at least a circle
            return CGSize(width: intrinsicHeight, height: intrinsicHeight)
        }

        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    
}


class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    
    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)
        
        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight
        
        return titleRect
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }
    
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength);
    }
    
    
}

