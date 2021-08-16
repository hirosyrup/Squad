//
//  PreferencesWindowController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/15.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    class func create() -> PreferencesWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PreferencesWindowController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! PreferencesWindowController
        return vc
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
