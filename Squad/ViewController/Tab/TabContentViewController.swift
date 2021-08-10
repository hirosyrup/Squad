//
//  TabContentViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa
import WebKit

class TabContentViewController: NSViewController, WKUIDelegate {
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
            webView?.uiDelegate = self
            webView?.customMenu = rightClickMenu
            webView?.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Safari/605.1.15"
            view.addSubview(webView!)
            webView?.load(URLRequest(url: initialUrl))
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }

    @objc func onSelectPreferences(_ sender: Any?) {
        
    }
}
