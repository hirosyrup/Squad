//
//  TabViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/09.
//

import Cocoa

class TabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabList = (try? PreferencesUserDefault().tabSettingDataList()) ?? []
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
}
