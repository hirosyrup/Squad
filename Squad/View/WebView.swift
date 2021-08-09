//
//  WebView.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import WebKit

class WebView: WKWebView {
    var customMenu: NSMenu?
    
    override func rightMouseDown(with event: NSEvent) {
        let isPressedCommand = event.modifierFlags.contains(NSEvent.ModifierFlags.command)
        guard isPressedCommand, let menu = customMenu else {
            super.rightMouseDown(with: event)
            return
        }
        
        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }
}
