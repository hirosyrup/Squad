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
    private let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("menu_bar_icon"))
            button.imagePosition = .imageLeft
            button.action = #selector(show(_:))
        }
        constructPopover()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    private func constructPopover() {
        let mainViewController = MainViewController.create()
        popover.contentViewController = mainViewController
        popover.behavior = .transient
        popover.animates = false
    }

    @objc func show(_ sender: Any?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        }
    }
}

