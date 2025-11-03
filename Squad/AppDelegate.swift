//
//  AppDelegate.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/08.
//

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private lazy var mainWindowController = MainWindowController.create()
    private lazy var statusItemController: StatusItemController = {
        let controller = StatusItemController()
        controller.onClick = { [weak self] in
            self?.toggleMainWindow()
        }
        return controller
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if #available(macOS 13.0, *) {
            statusItemController.deactivate()
        } else {
            statusItemController.activate()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        statusItemController.deactivate()
    }

    func toggleMainWindow() {
        if isMainWindowVisible {
            hideMainWindow()
        } else {
            showMainWindow()
        }
    }

    func showMainWindow() {
        mainWindowController.showWindow(self)
        let app = NSApplication.shared
        app.activate(ignoringOtherApps: true)
        app.windows.forEach { window in
            window.makeKeyAndOrderFront(app)
        }
    }

    func hideMainWindow() {
        NSApplication.shared.hide(self)
    }

    var isMainWindowVisible: Bool {
        NSApplication.shared.windows.filter { $0.canHide && $0.isVisible }.count > 0
    }
}
