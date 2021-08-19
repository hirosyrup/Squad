//
//  AppDelegate.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/08.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let mainWindowVc = MainWindowController.create()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("menu_bar_icon"))
            button.imagePosition = .imageLeft
            button.action = #selector(onClick(_:))
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func show() {
        mainWindowVc.showWindow(self)
        let app = NSApplication.shared
        app.activate(ignoringOtherApps: true)
        app.windows.forEach { window in
            window.makeKeyAndOrderFront(app)
        }
    }
    
    private func hide() {
        NSApplication.shared.hide(self)
    }
    
    private func hasVisibleWindow() -> Bool {
        return NSApplication.shared.windows.filter{$0.canHide && $0.isVisible}.count > 0
    }

    @objc func onClick(_ sender: Any?) {
        if hasVisibleWindow() {
            hide()
        } else {
            show()
        }
    }
}

