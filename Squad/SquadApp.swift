import SwiftUI
import AppKit

@main
struct SquadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Group {
            if #available(macOS 13.0, *) {
                MenuBarExtra("Squad", image: Image("menu_bar_icon")) {
                    MenuBarContent(appDelegate: appDelegate)
                }
            } else {
                WindowGroup(id: "legacyStatusItem") {
                    LegacyStatusItemPlaceholder()
                }
            }
        }
    }
}

@available(macOS 13.0, *)
private struct MenuBarContent: View {
    @State private var isWindowVisible = false
    private let appDelegate: AppDelegate

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: toggleWindow) {
                Text(isWindowVisible ? "メインウィンドウを隠す" : "メインウィンドウを表示")
            }
            Divider()
            Button("アプリケーションを終了") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(12)
        .frame(minWidth: 180)
        .onAppear {
            isWindowVisible = appDelegate.isMainWindowVisible
        }
    }

    private func toggleWindow() {
        appDelegate.toggleMainWindow()
        isWindowVisible = appDelegate.isMainWindowVisible
    }
}

private struct LegacyStatusItemPlaceholder: View {
    var body: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .onAppear {
                NSApplication.shared.hide(nil)
            }
    }
}
