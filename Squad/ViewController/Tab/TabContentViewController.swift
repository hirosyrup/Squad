//
//  TabContentViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa
import WebKit

class TabContentViewController: NSViewController, WKUIDelegate {
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
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
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if webView == nil {
            addWebView()
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        removeWebView()
    }
    
    func addWebView() {
        webView = WebView(frame: contentView.bounds)
        webView?.uiDelegate = self
        webView?.customMenu = rightClickMenu
        webView?.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Safari/605.1.15"
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        contentView.addSubview(webView!)
        webView?.load(URLRequest(url: initialUrl))
    }
    
    func removeWebView() {
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.isLoading))
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webView?.removeFromSuperview()
        webView = nil
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let _webView = webView else {
            return
        }

        switch keyPath {
        case #keyPath(WKWebView.isLoading), #keyPath(WKWebView.estimatedProgress):
            if _webView.isLoading {
                progressBar.isHidden = false
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.progressBar.animator().isHidden = true
                }
            }
            progressBar.doubleValue = Double(_webView.estimatedProgress)
        default:
            break
        }
    }

    @objc func onSelectPreferences(_ sender: Any?) {
        
    }
}
