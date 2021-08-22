//
//  CreateRigntClickMenu.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class CreateRigntClickMenu {
    class func menu(vc: NSViewController) -> NSMenu {
        let rightClickMenu = NSMenu(title: "right click menu")
        rightClickMenu.addItem(NSMenuItem(title: "About", action: #selector(vc.onSelectAbout(_:)), keyEquivalent: ""))
        rightClickMenu.addItem(NSMenuItem(title: "Preferences", action: #selector(vc.onSelectPreferences(_:)), keyEquivalent: ""))
        rightClickMenu.addItem(NSMenuItem(title: "Quit", action: #selector(vc.onSelectQuit(_:)), keyEquivalent: ""))
        return rightClickMenu
    }
}
