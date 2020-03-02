//
//  FMControlPanelViewController.swift
//  DouFM
//
//  Created by cissu on 2018/8/16.
//  Copyright © 2018年 cissu. All rights reserved.
//

import Cocoa

protocol FMControlProtocol : AnyObject {
    func FLCPPlayNext()
    func FLCPPause()
    func FLCPResume()
    func FLCPToggleLike()
    func FLCVolumeChanged(value : Int)
}

class FMControlPanelViewController: NSViewController {

    static let shared = FMControlPanelViewController(nibName: NSNib.Name(rawValue: "FMControlPanelViewController"), bundle: nil)
    
    @objc class func sharedInstance() -> FMControlPanelViewController {
        return shared
    }
    
    weak var delegate : FMControlProtocol?
    
    @IBOutlet weak var fastForward: NSButton!
    @IBOutlet weak var playButton: NSButton!
    @IBOutlet weak var imageView: FMAlbumPicView!
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var albumLabel: NSTextField!
    
    @IBOutlet var likeButton: NSButton!
    
    @IBOutlet weak var volumeSlider: NSSlider!
    
    @IBOutlet weak var volumeButton: NSButton!
    
    
    var channelList : Array<Dictionary<String, Any>>? {
        didSet {
            print("\(channelList)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        titleLabel.stringValue = ""
        albumLabel.stringValue = ""
        
        imageView.detailClickedHandler =  {
            () -> Void in
            FMWindowController.shared.showWindow(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
        
        changeImage()
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(darkModeChanged(notif:)), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    @IBAction func playOrPause(_ sender: Any) {
        if (playButton.state == NSControl.StateValue.on) {
            delegate?.FLCPResume()
            toPlay()
        }
        else {
            delegate?.FLCPPause()
            toPause()
        }
    }
    
    @IBAction func playNext(_ sender: Any) {
        delegate?.FLCPPlayNext()
    }
    
    @IBAction func toggleLike(_ sender: Any) {
        delegate?.FLCPToggleLike()
    }
    
    @IBAction func volumeChanged(_ sender: NSSlider) {
        delegate?.FLCVolumeChanged(value: sender.integerValue)
    }
    
    func toPause () {
        playButton.state = NSControl.StateValue.off
        changePlayImage()
    }
    
    func toPlay () {
        playButton.state = NSControl.StateValue.on
        changePlayImage()
    }
    
    func unLike() {
        likeButton.state = NSControl.StateValue.off
        changeLikeImage()
    }
    
    func like() {
        likeButton.state = NSControl.StateValue.on
        changeLikeImage()
    }
    
    func changeVolumeButtonImage() {
        if FMUtils.isDarkMode() {
            volumeButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_volume_up_black_18dp"))?.imageWithTintColor(tintColor: NSColor.white)
        }
        else {
            volumeButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_volume_up_black_18dp"))
        }
    }
    
    func changeLikeImage() {
        if FMUtils.isDarkMode() {
            if likeButton.state == NSControl.StateValue.on {
                likeButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_favorite_black_48dp"))?.imageWithTintColor(tintColor: NSColor.systemPink)
            }
            else {
                likeButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_favorite_border_black_48dp"))?.imageWithTintColor(tintColor: NSColor.white)
            }
        }
        else {
            if likeButton.state == NSControl.StateValue.on {
                likeButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_favorite_black_48dp"))?.imageWithTintColor(tintColor: NSColor.systemPink)
            }
            else {
                likeButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_favorite_border_black_48dp"))
            }
        }
    }
    
    func changePlayImage() {
        if FMUtils.isDarkMode() {
            if playButton.state == NSControl.StateValue.on {
                playButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_pause_black_48dp"))?.imageWithTintColor(tintColor: NSColor.white)
            }
            else {
                playButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_play_arrow_black_48dp"))?.imageWithTintColor(tintColor: NSColor.white)
            }
        }
        else {
            if playButton.state == NSControl.StateValue.on {
                playButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_pause_black_48dp"))
            }
            else {
                playButton.image = NSImage(named: NSImage.Name(rawValue: "baseline_play_arrow_black_48dp"))
            }
        }
    }
    
    func changeImage() {
        changeVolumeButtonImage()
        changePlayImage()
        changeLikeImage()
        if FMUtils.isDarkMode() {
            fastForward.image = NSImage(named: NSImage.Name(rawValue: "baseline_fast_forward_black_48dp"))?.imageWithTintColor(tintColor: NSColor.white)
        }
        else {
            fastForward.image = NSImage(named: NSImage.Name(rawValue: "baseline_fast_forward_black_48dp"))
        }
    }
    
    @objc func darkModeChanged(notif : Notification) {
        DispatchQueue.main.async {
            [weak self] in
            self?.changeImage()
        }
    }
    
    func changeAlbumImage(url : String) {
        DispatchQueue.global().async {
            if let data : Data = try? Data(contentsOf: URL(string: url)!) {
                if let image : NSImage = NSImage(data: data) {
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
}
