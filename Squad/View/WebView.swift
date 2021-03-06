//
//  WebView.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import WebKit

protocol WebViewDelegate {
    func onKeyDown(webView: WebView, event: NSEvent) -> Bool
}

class WebView: WKWebView {
    var customMenu: NSMenu?
    var delegate: WebViewDelegate?
    
    override func keyDown(with event: NSEvent) {
        let funcOnKeyDown = {(event: NSEvent) -> Void in
            let result = self.delegate?.onKeyDown(webView: self, event: event) ?? false
            if !result {
                super.keyDown(with: event)
            }
        }
        
        if event.modifierFlags.contains(NSEvent.ModifierFlags.command) {
            if event.modifierFlags.contains(NSEvent.ModifierFlags.shift) {
                switch event.keyCode {
                // command+shift+z
                case 6:
                    NSApp.sendAction(Selector(("redo:")), to: nil, from: self)
                default:
                    funcOnKeyDown(event)
                }
            } else {
                switch event.keyCode {
                // command+[
                case 30:
                    if canGoBack {
                        goBack()
                    }
                // command+]
                case 42:
                    if canGoForward {
                        goForward()
                    }
                // command+r
                case 15:
                    reload()
                // esc
                case 53:
                    stopLoading()
                // x
                case 7:
                    NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self)
                // c
                case 8:
                    NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self)
                // v
                case 9:
                    NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self)
                // z
                case 6:
                    NSApp.sendAction(Selector(("undo:")), to: nil, from: self)
                // a
                case 0:
                    NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: self)
                // w
                case 13:
                    window?.close()
                default:
                    funcOnKeyDown(event)
                }
            }
        } else {
            funcOnKeyDown(event)
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let isPressedCommand = event.modifierFlags.contains(NSEvent.ModifierFlags.command)
        guard isPressedCommand, let menu = customMenu else {
            super.rightMouseDown(with: event)
            return
        }
        
        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }
}
