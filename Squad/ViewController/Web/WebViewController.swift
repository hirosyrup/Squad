//
//  WebViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, WebViewDelegate {
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var controlView: NSView!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!
    @IBOutlet weak var reloadCancelButton: NSButton!
    @IBOutlet weak var urlTextField: NSTextField!
    
    private var initialUrl: URL!
    private var initialIsShowControlView: Bool!
    private var isDiscordWhenSwitchingTab: Bool!
    private var webView: WebView?
    private var rightClickMenu: NSMenu!
    
    class func create(initialUrl: URL, title: String, initialIsShowControlView: Bool, isDiscordWhenSwitchingTab: Bool) -> WebViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("WebViewController")
        let vc = storyboard.instantiateController(withIdentifier: identifier) as! WebViewController
        vc.initialUrl = initialUrl
        vc.initialIsShowControlView = initialIsShowControlView
        vc.isDiscordWhenSwitchingTab = isDiscordWhenSwitchingTab
        vc.title = title
        return vc
    }
    
    func setupFromWindow(initialUrl: URL, title: String, initialIsShowControlView: Bool, isDiscordWhenSwitchingTab: Bool) {
        self.initialUrl = initialUrl
        self.initialIsShowControlView = initialIsShowControlView
        self.isDiscordWhenSwitchingTab = isDiscordWhenSwitchingTab
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rightClickMenu = CreateRigntClickMenu.menu(
            preferenceAction: #selector(onSelectPreferences(_:)),
            quitAction: #selector(onSelectQuit(_:))
        )
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        controlView.isHidden = !initialIsShowControlView
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if webView == nil {
            addWebView()
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        if isDiscordWhenSwitchingTab {
            removeWebView()
        }
    }
    
    func addWebView() {
        webView = WebView(frame: contentView.bounds)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
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
    
    func updateControlView(webView: WKWebView) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        reloadCancelButton.image = webView.isLoading ? NSImage(systemSymbolName: "multiply", accessibilityDescription: nil) : NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil)
        if let url = webView.url {
            urlTextField.stringValue = url.absoluteString
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        updateControlView(webView: webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateControlView(webView: webView)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateControlView(webView: webView)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        let wc = WebWindowController.create(initialUrl: navigationAction.request.url!, initialSize: view.bounds.size)
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
        PreferencesWindowController.create().showWindow(self)
    }
    
    @objc func onSelectQuit(_ sender: Any?) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func onClickBackButton(_ sender: Any) {
        webView?.goBack()
    }
    
    @IBAction func onClickForwardButton(_ sender: Any) {
        webView?.goForward()
    }
    
    @IBAction func onClickReloadCancelButton(_ sender: Any) {
        guard let _webView = webView else {
            return
        }
        
        if _webView.isLoading {
            _webView.stopLoading()
        } else {
            _webView.reload()
        }
    }
    
    @IBAction func onClickExternalLinkButton(_ sender: Any) {
        guard let url = webView?.url else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}
