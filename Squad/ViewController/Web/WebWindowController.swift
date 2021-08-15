//
//  WebWindowController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/14.
//

import Cocoa
import CoreFoundation

class WebWindowController: NSWindowController, NSWindowDelegate {
    class func create(initialUrl: URL) -> WebWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("WebWindowController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! WebWindowController
        if let webVc = vc.contentViewController as? WebViewController {
            webVc.setupFromWindow(initialUrl: initialUrl, title: "")
        }
        return vc
    }
}
