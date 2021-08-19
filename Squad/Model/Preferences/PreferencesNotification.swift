//
//  PreferencesNotification.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/19.
//

import Foundation

class PreferencesNotification {
    private static let notificationName = NSNotification.Name("didChangePreferences")
    
    class func addObserver(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: notificationName,
            object: nil
        )
    }
    
    class func removeObserver(observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: notificationName, object: nil)
    }
    
    class func notify() {
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}
