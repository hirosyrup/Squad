//
//  TabSettingInputViewController.swift
//  Squad
//
//  Created by 岩井 宏晃 on 2021/08/15.
//

import Cocoa

protocol TabSettingInputViewControllerDelegate: AnyObject {
    func didUpdate(vc: TabSettingInputViewController)
}

class TabSettingInputViewController: NSViewController {

    @IBOutlet weak var titleTextField: EditableNSTextField!
    @IBOutlet weak var urlTextField: EditableNSTextField!
    @IBOutlet weak var showControlViewYesRaidoButton: NSButton!
    @IBOutlet weak var showControlViewNoRaidoButton: NSButton!
    @IBOutlet weak var discordYesRaidoButton: NSButton!
    @IBOutlet weak var discordNoRaidoButton: NSButton!
    @IBOutlet weak var widthTextField: NSTextField!
    @IBOutlet weak var heightTextField: NSTextField!
    
    private var tabSettingData: TabSettingData!
    weak var delegate: TabSettingInputViewControllerDelegate?
    
    func setupFromSegue(tabSettingData: TabSettingData) {
        self.tabSettingData = tabSettingData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        titleTextField.stringValue = tabSettingData.title
        urlTextField.stringValue = tabSettingData.url
        showControlViewYesRaidoButton.state = tabSettingData.isShowControlView ? .on : .off
        showControlViewNoRaidoButton.state = tabSettingData.isShowControlView ? .off : .on
        discordYesRaidoButton.state = tabSettingData.isDiscordWhenSwitchingTab ? .on : .off
        discordNoRaidoButton.state = tabSettingData.isDiscordWhenSwitchingTab ? .off : .on
        widthTextField.stringValue = "\(tabSettingData.width)"
        heightTextField.stringValue = "\(tabSettingData.height)"
    }
    
    @IBAction func onClickShowControlViewRaidoButton(_ sender: Any) {
    }
    
    @IBAction func onClickDiscordRaidoButton(_ sender: Any) {
    }
    
    @IBAction func onClickOkButton(_ sender: Any) {
        let data = TabSettingData(
            id: tabSettingData.id,
            title: titleTextField.stringValue,
            url: urlTextField.stringValue,
            isShowControlView: showControlViewYesRaidoButton.state == .on,
            isDiscordWhenSwitchingTab: discordYesRaidoButton.state == .on,
            width: Int(widthTextField.stringValue) ?? tabSettingData.width,
            height: Int(heightTextField.stringValue) ?? tabSettingData.height
        )
        try? PreferencesUserDefault().saveTabSettingData(data: data)
        delegate?.didUpdate(vc: self)
        dismiss(self)
    }
    
    @IBAction func onClickCancelButton(_ sender: Any) {
        dismiss(self)
    }
}
