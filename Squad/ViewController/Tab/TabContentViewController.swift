//
//  TabContentViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class TabContentViewController: NSViewController {
    private var initialUrl: URL!
    private var webView: WebView?
    private var rightClickMenu: NSMenu!
    
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
        
        rightClickMenu = CreateRigntClickMenu.menu(
            preferenceAction: #selector(onSelectPreferences(_:))
        )
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if webView == nil {
            webView = WebView(frame: view.bounds)
            webView?.customMenu = rightClickMenu
            view.addSubview(webView!)
            webView?.load(URLRequest(url: initialUrl))
        }
    }
    
    @objc func onSelectPreferences(_ sender: Any?) {
        
    }
}
