//
//  WebWindowController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/14.
//

import Cocoa
import CoreFoundation

class WebWindowController: NSWindowController {
    class func create(initialUrl: URL, initialSize: NSSize?) -> WebWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("WebWindowController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! WebWindowController
        if let _initialSize = initialSize {
            vc.window?.setContentSize(_initialSize)
        }
        if let webVc = vc.contentViewController as? WebViewController {
            webVc.setupFromWindow(initialUrl: initialUrl, title: "", initialIsShowControlView: true, isDiscordWhenSwitchingTab: false)
        }
        return vc
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
