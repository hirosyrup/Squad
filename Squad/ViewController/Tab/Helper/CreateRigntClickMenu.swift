//
//  CreateRigntClickMenu.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class CreateRigntClickMenu {
    class func menu(
        preferenceAction: Selector,
        backAction: Selector,
        fowardAction: Selector,
        reloadAction: Selector
    ) -> NSMenu {
        let rightClickMenu = NSMenu(title: "right click menu")
        rightClickMenu.addItem(NSMenuItem(title: "Preferences", action: preferenceAction, keyEquivalent: ""))
        rightClickMenu.addItem(NSMenuItem.separator())
        rightClickMenu.addItem(NSMenuItem(title: "Back", action: backAction, keyEquivalent: ""))
        rightClickMenu.addItem(NSMenuItem(title: "Forward", action: fowardAction, keyEquivalent: ""))
        rightClickMenu.addItem(NSMenuItem(title: "Reload", action: reloadAction, keyEquivalent: ""))
        return rightClickMenu
    }
}
