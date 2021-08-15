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
    let url: String
    let isShowControlView: Bool
    let isDiscordWhenSwitchingTab: Bool
    let width: Int
    let height: Int
    
    static func new() -> TabSettingData {
        return TabSettingData(id: UUID().uuidString, title: "", url: "", isShowControlView: false, isDiscordWhenSwitchingTab: false, width: 1920, height: 1200)
    }
}
