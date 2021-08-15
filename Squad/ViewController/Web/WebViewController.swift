//
//  WebViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, WKUIDelegate, WebViewDelegate {
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var controlView: NSView!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    private var initialUrl: URL!
    private var webView: WebView?
    private var rightClickMenu: NSMenu!
    
    class func create(initialUrl: URL, title: String) -> WebViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("WebViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! WebViewController
        vc.initialUrl = initialUrl
        vc.title = title
        return vc
    }
    
    func setupFromWindow(initialUrl: URL, title: String) {
        self.initialUrl = initialUrl
        self.title = title
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
        webView?.delegate = self
        webView?.customMenu = rightClickMenu
        webView?.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Safari/605.1.15 Chrome/92.0.4515.131"
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView?.autoresizingMask = [.height, .width]
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
        let wc = WebWindowController.create(initialUrl: navigationAction.request.url!)
        wc.showWindow(self)
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
    
    func onKeyDown(webView: WebView, event: NSEvent) -> Bool {
        if event.modifierFlags.contains(NSEvent.ModifierFlags.command) &&
            event.modifierFlags.contains(NSEvent.ModifierFlags.option) &&
            event.keyCode == 34 {
            // coomand+option+i
            controlView.isHidden = !controlView.isHidden
            return true
        }
        return false
    }

    @objc func onSelectPreferences(_ sender: Any?) {
        
    }
}
