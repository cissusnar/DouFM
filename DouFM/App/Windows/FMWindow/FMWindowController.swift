//
//  FMWindowController.swift
//  DouFM
//
//  Created by cissu on 2018/8/16.
//  Copyright © 2018年 cissu. All rights reserved.
//

import Cocoa

class FMWindowController: NSWindowController {
    
    
    static let shared : FMWindowController = FMWindowController(windowNibName: NSNib.Name(rawValue: "FMWindowController"))
    
    //! objc singleton
    @objc class func sharedInstance() -> FMWindowController {
        return shared
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        window?.title = "豆瓣FM"
        
        if UserDefaults.standard.object(forKey: "firstboot") == nil {
            window?.setFrame(NSMakeRect(0, 0, 1280, 720), display: true)
            window?.center()
            UserDefaults.standard.set(true, forKey: "firstboot")
        }
        
        let fmVC = FMWebViewController.init(nibName: NSNib.Name(rawValue: "FMWebViewController"), bundle: nil)
        self.contentViewController = fmVC
        
        
        //! keep the following in last line of this function
        window?.setFrameAutosaveName(NSWindow.FrameAutosaveName("FMWebViewWindow"))
    }
    
}
