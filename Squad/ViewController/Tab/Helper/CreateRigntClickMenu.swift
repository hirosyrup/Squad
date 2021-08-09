//
//  CreateRigntClickMenu.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class CreateRigntClickMenu {
    class func menu(
        preferenceAction: Selector
    ) -> NSMenu {
        let rightClickMenu = NSMenu(title: "right click menu")
        rightClickMenu.addItem(NSMenuItem(title: "Preferences", action: preferenceAction, keyEquivalent: ""))
        return rightClickMenu
    }
}
