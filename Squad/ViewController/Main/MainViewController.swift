//
//  MainViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/08.
//

import Cocoa

class MainViewController: NSViewController {
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var noteLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PreferencesNotification.addObserver(observer: self, selector: #selector(didChangePreferences(_:)))
        updateViews()
    }
    
    private func updateViews() {
        let needTabSetting = ((try? PreferencesUserDefault().tabSettingDataList()) ?? []).isEmpty
        containerView.isHidden = needTabSetting
        noteLabel.isHidden = !needTabSetting
    }
    
    override func rightMouseDown(with event: NSEvent) {
        let isPressedCommand = event.modifierFlags.contains(NSEvent.ModifierFlags.command)
        guard isPressedCommand else {
            super.rightMouseDown(with: event)
            return
        }
        
        let rightClickMenu = CreateRigntClickMenu.menu(
            preferenceAction: #selector(onSelectPreferences(_:))
        )
        
        NSMenu.popUpContextMenu(rightClickMenu, with: event, for: view)
    }
    
    @objc func onSelectPreferences(_ sender: Any?) {
        PreferencesWindowController.create().showWindow(self)
    }
    
    @objc func didChangePreferences(_ sender: Any?) {
        updateViews()
    }
}

