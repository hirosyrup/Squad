//
//  TabContentViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class TabContentViewController: NSViewController {
    private var initialUrl: URL!
    
    class func create(initialUrl: URL, title: String) -> TabContentViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("TabContentViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! TabContentViewController
        vc.initialUrl = initialUrl
        vc.title = title
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let rightClickMenu = CreateRigntClickMenu.menu(
            preferenceAction: #selector(onSelectPreferences(_:)),
            backAction: #selector(onSelectBack(_:)),
            fowardAction: #selector(onSelectForward(_:)),
            reloadAction: #selector(onSelectReload(_:))
        )
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
