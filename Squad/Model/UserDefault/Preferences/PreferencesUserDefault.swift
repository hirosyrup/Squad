//
//  PreferencesUserDefault.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/15.
//

import Foundation

class PreferencesUserDefault {
    let userDefault = UserDefaults.standard
    
    let tabSettingKey = "tabSetting"
    
    init() {
        userDefault.register(defaults: [tabSettingKey: Data()])
    }
    
    func saveTabSettingData(data: TabSettingData) throws {
        var dataList = try tabSettingDataList()
        if let index = dataList.firstIndex(where: { $0.id == data.id }) {
            dataList[index] = data
        } else {
            dataList.append(data)
        }
        try saveTabSettingSataList(dataList: dataList)
    }
    
    func deleteTabSettingData(data: TabSettingData) throws {
        var dataList = try tabSettingDataList()
        dataList.removeAll(where: { $0.id == data.id })
        try saveTabSettingSataList(dataList: dataList)
    }
    
    func resetAll() {
        userDefault.set(Data(), forKey: tabSettingKey)
    }
    
    func tabSettingDataList() throws -> [TabSettingData] {
        guard let data = userDefault.data(forKey: tabSettingKey), !data.isEmpty else {
            return []
        }
        
        return try JSONDecoder().decode(Array<TabSettingData>.self, from: data)
    }
    
    private func saveTabSettingSataList(dataList: [TabSettingData]) throws {
        let json = try JSONEncoder().encode(dataList)
        userDefault.set(json, forKey: tabSettingKey)
    }
}
