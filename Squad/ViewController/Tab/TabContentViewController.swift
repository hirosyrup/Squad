//
//  TabContentViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class TabContentViewController: NSViewController {

    private var rightClickMenu: NSMenu!
    
    class func create() -> TabContentViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("TabContentViewController")
        return storyboard.instantiateController(withIdentifier: identifier) as! TabContentViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rightClickMenu = CreateRigntClickMenu.menu(
            preferenceAction: #selector(onSelectPreferences(_:)),
            backAction: #selector(onSelectBack(_:)),
            fowardAction: #selector(onSelectForward(_:)),
            reloadAction: #selector(onSelectReload(_:))
        )
    }
    
    override func rightMouseDown(with event: NSEvent) {
        NSMenu.popUpContextMenu(rightClickMenu, with: event, for: view)
    }
    
    @objc func onSelectPreferences(_ sender: Any?) {
        
    }
    
    @objc func onSelectBack(_ sender: Any?) {
        
    }
    
    @objc func onSelectForward(_ sender: Any?) {
        
    }
    
    @objc func onSelectReload(_ sender: Any?) {
        
    }
}
