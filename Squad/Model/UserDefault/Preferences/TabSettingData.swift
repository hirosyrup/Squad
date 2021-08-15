//
//  TabSettingData.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/15.
//

import Foundation

struct TabSettingData: Codable {
    let id: String
    let title: String
    let isShowControlView: Bool
    let isDiscordWhenSwitchingTab: Bool
    
    static func new() -> TabSettingData {
        return TabSettingData(id: UUID().uuidString, title: "", isShowControlView: false, isDiscordWhenSwitchingTab: false)
    }
}
