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
        
        addChild(WebViewController.create(initialUrl: URL(string: "https://www.google.co.jp/")!, title: "Test"))
    }
}
