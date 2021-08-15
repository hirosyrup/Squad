//
//  TabSettingRowPresenter.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/15.
//

import Foundation

class TabSettingRowPresenter {
    private let data: TabSettingData
    
    init(data: TabSettingData) {
        self.data = data
    }
    
    func title() -> String {
        return data.title
    }
    
    func url() -> String {
        return data.url
    }
    
    func showControlViewText() -> String {
        return data.isShowControlView ? "Yes" : "No"
    }
    
    func discordWhenSwitchingTabText() -> String {
        return data.isDiscordWhenSwitchingTab ? "Yes" : "No"
    }
}
