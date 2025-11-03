import Cocoa

final class StatusItemController: NSObject {
    var onClick: (() -> Void)?
    private var statusItem: NSStatusItem?

    func activate() {
        guard statusItem == nil else {
            return
        }

        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        configure(button: item.button)
        statusItem = item
    }

    func deactivate() {
        if let item = statusItem {
            NSStatusBar.system.removeStatusItem(item)
        }
        statusItem = nil
    }

    private func configure(button: NSStatusBarButton?) {
        guard let button else {
            return
        }

        button.image = NSImage(named: NSImage.Name("menu_bar_icon"))
        button.imagePosition = .imageLeft
        button.target = self
        button.action = #selector(onSelect(_:))
    }

    @objc private func onSelect(_ sender: Any?) {
        onClick?()
    }
}
