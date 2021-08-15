//
//  TabSettingViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/15.
//

import Cocoa

class TabSettingViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, TabSettingInputViewControllerDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    @IBOutlet weak var editButton: NSButton!
    private var dataList = [TabSettingData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        dataList = (try? PreferencesUserDefault().tabSettingDataList()) ?? []
        updateViews()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let vc = segue.destinationController as? TabSettingInputViewController {
            vc.delegate = self
            switch segue.identifier {
            case "New":
                vc.setupFromSegue(tabSettingData: TabSettingData.new())
            case "Edit":
                let data = tableView.selectedRow != -1 ? dataList[tableView.selectedRow] : TabSettingData.new()
                vc.setupFromSegue(tabSettingData: data)
            default:
                break
            }
        }
    }
    
    private func reloadDataList() {
        dataList = (try? PreferencesUserDefault().tabSettingDataList()) ?? []
        tableView.reloadData()
    }
    
    private func updateViews() {
        let isSelectedRow = tableView.selectedRow != -1
        deleteButton.isEnabled = isSelectedRow
        editButton.isEnabled = isSelectedRow
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let identifier = tableColumn?.identifier else {
            return ""
        }
        let presenter = TabSettingRowPresenter(data: dataList[row])
        switch identifier.rawValue {
        case "First":
            return presenter.title()
        case "Second":
            return presenter.url()
        case "Third":
            return presenter.showControlViewText()
        case "Fourth":
            return presenter.discordWhenSwitchingTabText()
        case "Fifth":
            return presenter.windowSizeText()
        default:
            return ""
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        updateViews()
    }
    
    func didUpdate(vc: TabSettingInputViewController) {
        reloadDataList()
    }
    
    @IBAction func onClickDeleteButton(_ sender: Any) {
        guard tableView.selectedRow != -1 else {
            return
        }
        
        try? PreferencesUserDefault().deleteTabSettingData(data: dataList[tableView.selectedRow])
        reloadDataList()
    }
}
