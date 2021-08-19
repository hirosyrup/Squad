//
//  TabViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class TabViewController: NSTabViewController {

    private var tabList = [TabSettingData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        PreferencesNotification.addObserver(observer: self, selector: #selector(didChangePreferences(_:)))
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        setWindowSize(tabViewItem: tabView.selectedTabViewItem)
    }
    
    private func setup() {
        children.removeAll()
        
        tabList = (try? PreferencesUserDefault().tabSettingDataList()) ?? []
        tabList.forEach {
            if let url = URL(string: $0.url) {
                addChild(WebViewController.create(
                    initialUrl: url,
                    title: $0.title,
                    initialIsShowControlView: $0.isShowControlView,
                    isDiscordWhenSwitchingTab: $0.isDiscordWhenSwitchingTab)
                )
            }
        }
    }
    
    private func setWindowSize(tabViewItem: NSTabViewItem?) {
        if let index = tabView.tabViewItems.firstIndex(where: { $0 === tabViewItem }) {
            let tab = tabList[index]
            view.window?.setContentSize(NSSize(width: tab.width, height: tab.height))
        }
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        setWindowSize(tabViewItem: tabViewItem)
    }
    
    @objc func didChangePreferences(_ sender: Any?) {
        setup()
    }
}
