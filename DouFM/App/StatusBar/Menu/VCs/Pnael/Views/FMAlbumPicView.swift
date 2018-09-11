//
//  FMAlbumPicView.swift
//  DouFM
//
//  Created by cissu on 2018/8/18.
//  Copyright © 2018年 cissu. All rights reserved.
//

import Cocoa

class FMAlbumPicView: NSImageView {

    

    var mouseInHandler : (() -> (Void))?
    var mouseOutHandler : (() -> (Void))?
    
    var detailClickedHandler : (() -> (Void))?
    
    var mouseIned : Bool = false
    
    lazy var detailButton : NSButton = {
        let button = NSButton()
        button.isHidden = true
        button.isBordered = false
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        
        let shadow : NSShadow = NSShadow()
        shadow.shadowColor = NSColor.black
        shadow.shadowOffset = NSZeroSize
        shadow.shadowBlurRadius = 3.0
        
        let strokeTextAttributes: [NSAttributedStringKey: Any] = [
            .strokeColor : NSColor.black,
            .foregroundColor : NSColor.white,
            .strokeWidth : -2.0,
            .font : NSFont.boldSystemFont(ofSize: 14),
            .shadow : shadow,
            .paragraphStyle : pstyle
        ]
        
        let title : NSAttributedString = NSAttributedString(string: "点击 显示详情", attributes: strokeTextAttributes)
        
        button.attributedTitle = title
        button.target = self
        button.action = #selector(buttonClicked(sendor:))
        self.addSubview(button)
        return button
    }()
    
    lazy var trackingArea : NSTrackingArea = {
        let trackingArea = NSTrackingArea(rect: NSZeroRect, options:[.inVisibleRect, .activeAlways, .mouseEnteredAndExited] , owner: self, userInfo: nil)
        return trackingArea
    }()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if !self.trackingAreas.contains(trackingArea) {
            self.addTrackingArea(trackingArea)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        mouseIned = true
        mouseInHandler?()
        detailButton.isHidden = false
        self.needsDisplay = true
    }
    
    override func mouseExited(with event: NSEvent) {
        mouseIned = false
        detailButton.isHidden = true
        mouseOutHandler?()
        self.needsDisplay = true
    }
    
    override func layout() {
        super.layout()
        detailButton.frame = bounds
    }
    
    @objc func buttonClicked(sendor : Any) {
        detailClickedHandler?()
    }
    
}
