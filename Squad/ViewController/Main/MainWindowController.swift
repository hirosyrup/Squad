//
//  MainWindowController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/15.
//

import Cocoa

class MainWindowController: NSWindowController {
    class func create() -> MainWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MainWindowController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! MainWindowController
        return vc
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
