//
//  StatusBarController.swift
//  DouFM
//
//  Created by cissu on 2018/8/16.
//  Copyright © 2018年 cissu. All rights reserved.
//

import Cocoa

class StatusBarController: NSObject {
    
    static let shared :StatusBarController = StatusBarController()
    
    let trayItem : NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    override init() {
        super.init()
        trayItem.menu = FMControlPanelMenuManager.shared.mainMenu()
        changeItemImage()
        trayItem.target = self
        trayItem.action = #selector(clicked)
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(darkModeChanged(notif:)), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    @objc class func sharedInstance() -> StatusBarController {
        return shared
    }
    
    func changeItemImage() {
        if FMUtils.isDarkMode() {
            trayItem.button?.image = NSImage(named: NSImage.Name(rawValue: "baseline_radio_black_18dp"))?.imageWithTintColor(tintColor: NSColor.white)
        }
        else {
            trayItem.button?.image = NSImage(named: NSImage.Name(rawValue: "baseline_radio_black_18dp"))
        }
    }
    
    @objc func clicked() {
        
    }
    
    @objc func darkModeChanged(notif : Notification) {
        DispatchQueue.main.async {
            [weak self] in
            self?.changeItemImage()
        }
    }
}
