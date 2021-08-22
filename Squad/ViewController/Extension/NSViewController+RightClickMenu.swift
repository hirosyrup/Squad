//
//  NSViewController+RightClickMenu.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/22.
//

import Cocoa

extension NSViewController {
    @objc func onSelectPreferences(_ sender: Any?) {
        PreferencesWindowController.create().showWindow(self)
    }
    
    @objc func onSelectQuit(_ sender: Any?) {
        NSApplication.shared.terminate(self)
    }
}
