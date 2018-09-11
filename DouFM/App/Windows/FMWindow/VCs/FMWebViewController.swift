//
//  FMWebViewController.swift
//  DouFM
//
//  Created by cissu on 2018/8/16.
//  Copyright © 2018年 cissu. All rights reserved.
//

import Cocoa
import WebKit

class FMWebViewController: NSViewController, FMControlProtocol, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {


        
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FMControlPanelViewController.shared.delegate = self
        // Do view setup here.
        
        let configure = WKWebViewConfiguration()
        
        let js : String = """
dr.on("like", function() { webkit.messageHandlers.like.postMessage(null); });
dr.on("login", function() { webkit.messageHandlers.login.postMessage(null); });
dr.on("logout", function() { webkit.messageHandlers.logout.postMessage(null); });
dr.on("pause", function() { webkit.messageHandlers.pause.postMessage(null); });
dr.on("play", function() { webkit.messageHandlers.play.postMessage(null); });
// dr.on("playing", function() { webkit.messageHandlers.playing.postMessage(dr.currentSong); });
dr.on("resume", function() { webkit.messageHandlers.resume.postMessage(null); });
dr.on("switch_channel", function() { webkit.messageHandlers.switch_channel.postMessage(null); });
dr.on("switch_song", function() { webkit.messageHandlers.switch_song.postMessage(null); });
dr.on("switch_songlist", function() { webkit.messageHandlers.switch_songlist.postMessage(null); });
dr.on("unlike", function() { webkit.messageHandlers.unlike.postMessage(null); });

"""
        
        let script = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)

        configure.userContentController.add(self, name: "like")
        configure.userContentController.add(self, name: "login")
        configure.userContentController.add(self, name: "logout")
        configure.userContentController.add(self, name: "pause")
        configure.userContentController.add(self, name: "play")
//        configure.userContentController.add(self, name: "playing")
        configure.userContentController.add(self, name: "resume")
        configure.userContentController.add(self, name: "switch_channel")
        configure.userContentController.add(self, name: "switch_song")
        configure.userContentController.add(self, name: "switch_songlist")
        configure.userContentController.add(self, name: "unlike")
        
        configure.userContentController.addUserScript(script)
        
        webView = WKWebView(frame: self.view.bounds, configuration: configure)
        
        self.view.addSubview(webView)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(URLRequest(url: URL(string: "https://douban.fm")!))

        
        initChannelList()
    }
    
    func next() {
        webView!.evaluateJavaScript("dr._onfinish()") { (result, error) in
            
        }
    }
    
    func play() {
        webView!.evaluateJavaScript("dr.currentAudio.audio.resume()") { (result, error) in
            
        }
    }

    func pause() {
        webView!.evaluateJavaScript("dr.currentAudio.audio.pause()") { (result, error) in
            
        }
    }
    
    func toggleLike() {
        webView!.evaluateJavaScript("dr.toggleLike()") { (result, error) in
            
        }
    }
    
    func changeVolume(value : Int) {
        webView!.evaluateJavaScript("dr.setVolume(\(value))") { (result, error) in
            
        }
    }
    
    func currentVolume() {
        webView!.evaluateJavaScript("dr.getVolume()") { (result, error) in
            if let value : Int = result as? Int {
                FMControlPanelViewController.shared.volumeSlider.integerValue = value
            }
        }
    }
    
    func onBootCheck() {
        let js = """
if (dr.currentSong == null) {
    dr.skip()
}
"""
        webView!.evaluateJavaScript(js) { (result, error) in
            
        }
    }
    
    func songInfo() {
        webView!.evaluateJavaScript("dr.currentSong.attributes") { (result, error) in
            if let dict : Dictionary<String, Any> = result as? Dictionary<String, Any> {
                if let picture : String = dict["picture"] as? String {
                    FMControlPanelViewController.shared.changeAlbumImage(url: picture)
                }
                if let title : String = dict["title"] as? String {
                    FMControlPanelViewController.shared.titleLabel.stringValue = title
                }
                
                if let albumTitle : String = dict["albumtitle"] as? String {
                    FMControlPanelViewController.shared.albumLabel.stringValue = albumTitle
                }
                
                if let like : Bool = dict["like"] as? Bool {
                    if like {
                        FMControlPanelViewController.shared.like()
                    }
                    else {
                        FMControlPanelViewController.shared.unLike()
                    }
                }
                else if let like : String = dict["like"] as? String {
                    if like == "1" {
                        FMControlPanelViewController.shared.like()
                    }
                    else {
                        FMControlPanelViewController.shared.unLike()
                    }
                }
            }
        }
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        webView?.frame = self.view.bounds
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }

    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received message: \(message.name)")
        
        switch message.name {
        case "like":
            FMControlPanelViewController.shared.like()
            break
        case "login":
            break
        case "logout":
            break
        case "pause":
            FMControlPanelViewController.shared.toPause()
            break
        case "play":
            FMControlPanelViewController.shared.toPlay()
            break
        case "playing":
            break
        case "resume":
            FMControlPanelViewController.shared.toPlay()
            break
        case "switch_channel":
            break
        case "switch_song":
            DispatchQueue.main.async {
                [weak self] in
                self?.songInfo()
            }
            break
        case "switch_songlist":
            break
        case "unlike":
            FMControlPanelViewController.shared.unLike()
            break
        default:
            break
        }
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            print("### URL:", self.webView.url!)
        }
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // When page load finishes. Should work on each page reload.
            if (self.webView.estimatedProgress == 1) {
                print("### EP:", self.webView.estimatedProgress)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 2000000000), execute: { [weak self]
                    ()->Void in
                    self?.onBootCheck()
                    self?.currentVolume()
                })
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("here")
    }
    
    func FLCPPlayNext() {
        next()
    }
    
    func FLCPPause() {
        pause()
    }
    
    func FLCPResume() {
        play()
    }
    
    func FLCPToggleLike() {
        toggleLike()
    }
    
    func FLCVolumeChanged(value: Int) {
        changeVolume(value: value)
    }
    
    func initChannelList() {
        DispatchQueue.global().async {
            if let data : Data = try? Data(contentsOf: URL(string: "https://www.douban.com/j/app/radio/channels")!) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any> {
                    if let channels = jsonObject?["channels"] as? Array<Dictionary<String, Any>> {
                        FMControlPanelViewController.shared.channelList = channels
                    }
                }
            }
        }
    }
    
}
