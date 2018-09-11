//
//  FMControlPanelMenuManager.swift
//  DouFM
//
//  Created by cissu on 2018/8/16.
//  Copyright © 2018年 cissu. All rights reserved.
//

import Cocoa

class FMControlPanelMenuManager: NSObject {
    
    static let shared : FMControlPanelMenuManager = FMControlPanelMenuManager()
    
    private let controlMenu : NSMenu = NSMenu(title: "")
    
    let controlPanelViewController = FMControlPanelViewController.shared
    
    @objc func mainMenu() -> NSMenu {
        return controlMenu
    }
    
    override init() {
        super.init()
        buildMenu()
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(darkModeChanged(notif:)), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    @objc class func sharedInstance() -> FMControlPanelMenuManager {
        return shared
    }
    
    func buildMenu() {
        controlMenu.removeAllItems()
        let item = NSMenuItem()
        let view = controlPanelViewController.view
        view.frame = NSMakeRect(0, 0, 535, 221)
        item.view = view
        controlMenu.addItem(item)
    }
    
    func showMenu() {
        
    }
    
    
    @objc func darkModeChanged(notif : Notification) {
        
    }
}
