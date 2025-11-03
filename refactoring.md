## SwiftUIリファクタリング計画

### ゴールと前提
- 3年間更新されていないAppKitベース（Storyboard＋ViewController構成）のmacOSアプリを、最新のSwiftUIアーキテクチャへ置き換え、保守性と拡張性を高める。
- 既存機能（ステータスバー常駐、タブ管理付きWebビューワ、Preferencesウィンドウ、Aboutダイアログ、リンクの外部ウィンドウ表示など）を同等以上に維持する。
- 対応OSバージョンを検討し、SwiftUI 4/5のAPI（`MenuBarExtra`、`Settings`シーン、`WindowGroup`、`@Observable`など）を最大限活用する。

### 現状の主な機能と課題
- ステータスバーのNSStatusItemをクリックしてメインウィンドウの表示・非表示を切り替えている。
- メインウィンドウは`MainWindowController`＋`MainViewController`で構成され、タブ設定が空の場合に注意文を表示するなどのUI制御を行う。
- `TabViewController`がユーザ設定から読み込んだ複数のWebビュータブを生成し、タブ切り替え時にウィンドウサイズを変更している。
- `WebViewController`はWKWebViewを直接組み込み、カスタムJavaScript、右クリックメニュー、キーボードショートカット、外部リンクの開き方切り替えなど複雑な挙動を実装している。
- ユーザ設定は`PreferencesUserDefault`と`TabSettingData`でJSONエンコードし、独自の通知クラス`PreferencesNotification`でビュー更新を連携している。
- 設定画面はNSTableView＋モーダル入力ViewControllerを使ってタブ設定を追加・編集し、`EditableNSTextField`でショートカットを補完している。
- 右クリックメニューやAboutウィンドウなど、Storyboard依存の補助UIが多数存在する。

### 全体戦略
1. **Storyboard依存からの脱却**  
   SwiftUIエントリポイント（`@main struct ... : App`）へ移行しつつ、必要な箇所は`NSApplicationDelegateAdaptor`や`NSWindowRepresentable`で段階的にブリッジする。
2. **状態管理の再設計**  
   `PreferencesUserDefault`を基盤に、`ObservableObject`や`@AppStorage`でラップした`PreferencesStore`/`TabSettingsStore`を定義。旧`NotificationCenter`連携をCombine/SwiftUIのデータバインディングに置き換える。
3. **UIのSwiftUI化**  
   メインコンテンツ、タブ管理、設定画面、補助ウィンドウをSwiftUIビュー＋Sceneに再構築。WKWebViewは`NSViewRepresentable`でラップし、既存のキーハンドリングとメニューをCoordinatorで移植する。
4. **モジュール分割とテスト容易性向上**  
   ViewModel層を導入してビジネスロジックとUIを分離。Codableな設定データにはユニットテストを追加し、UIはSnapshotや`ViewInspector`によるテストを検討する。

### フェーズ別計画

#### フェーズ1: プロジェクト基盤更新
- Xcodeプロジェクトの最小macOSバージョンとSwiftバージョンを見直し、SwiftUI 5対応のビルド設定を適用。
- `SquadApp`（SwiftUI `App`）を新規追加し、現行`AppDelegate`のロジック（ステータスバー構築、ウィンドウ制御）を`NSApplicationDelegateAdaptor`経由で段階的に移植。`MenuBarExtra`が使えるバージョンならそちらを優先し、非対応バージョン向けには独自`StatusItemController`を用意。
- Storyboard参照を最小化するため、ビルド設定からMain storyboardの指定を外す準備を行う。

#### フェーズ2: データ・状態管理レイヤー刷新
- 既存の`PreferencesUserDefault`と`TabSettingData`を基に、`TabSettingsStore`（ObservableObject）を実装。`@Published var tabs: [TabSetting]`などを提供し、Codable永続化を内部で委譲。
- 旧`PreferencesNotification`を廃止し、Storeの`objectWillChange`/`@Published`でSwiftUIビューを更新。
- タブ設定行の表示文言は`TabSettingRowPresenter`のロジックをViewModelや`Computed property`へ移行。
- ユニットテストで保存・読込・削除ロジックを検証し、将来の拡張に備える。

#### フェーズ3: メインウィンドウとタブUIのSwiftUI化
- SwiftUIの`WindowGroup`または`.window`モディファイアでメインウィンドウを生成し、`MainView`（SwiftUI）を構築。タブ設定が空の場合のメッセージ表示ロジックを`if tabs.isEmpty`で再現。
- `TabView`またはカスタムタブバーで`TabSettingsStore.tabs`を動的に描画。選択タブ変更時に`NSWindow`のサイズを更新するため、`WindowReader`（macOS 14）や`AppKit`ブリッジを用いたサイズ制御をCoordinatorで実装。
- 右クリックメニューはSwiftUIの`contextMenu`や`Commands`で再現し、⌘＋右クリックの条件を`NSViewRepresentable`側で判定して表示。
- 既存`MainWindowController`のショートカット（⌘W）対応は、SwiftUIの`.commands`や`KeyboardShortcut`で実装し、必要なら`NSWindow`ラッパーで補完。

#### フェーズ4: Webビューレイヤー移行
- 既存`WebView`クラスのショートカット処理・カスタムメニューを、`WKWebViewRepresentable`＋`Coordinator`に落とし込み、キーダウンや右クリックを`NSResponder`ブリッジで実現。
- `WebViewController`の責務を`WebTabView`（SwiftUI View）＋`WebTabViewModel`へ分割。  
  - `addWebView`相当の初期化・ユーザスクリプト登録をCoordinatorで行う。  
  - 読み込み状態／プログレスバー／戻る・進むボタンなどのUIをSwiftUIで構築。
- 外部リンク開き分岐は`TabSettingsStore.openLinkInExternalBrowser`などの設定値にバインドし、`NSWorkspace`呼び出しはCoordinator経由で行う。
- タブ切り替え時の`isDiscordWhenSwitchingTab`（タブ移動でWebViewを破棄する挙動）も状態として保持し、SwiftUI側でViewの再生成／破棄を制御。

#### フェーズ5: 設定画面と補助ウィンドウのSwiftUI化
- `Settings`シーン（macOS 13+）または独自ウィンドウでPreferences UIを再設計。`List`/`Form`でタブ一覧、トグル、数値入力を提供。`EditableNSTextField`のショートカット対応は標準TextField＋`.keyboardShortcut`、必要なら`TextFieldRepresentable`で補う。
- 追加/編集モーダルは`Sheet`や`NavigationStack`で表現し、`TabSettingInputView`としてリファクタリング。
- About画面は`WindowGroup(id: "about")`や`.commands { CommandGroup(replacing: .appInfo) }`で提供し、バージョン情報をSwiftUIテキストにバインド。
- 外部Webウィンドウ（`WebWindowController`）は`WindowGroup(id: "externalWeb")`と`openWindow` APIで開くようにし、サイズ指定を`windowResizability`や`NSWindow`ブリッジで制御。

#### フェーズ6: メニュー＆コマンド体系の整備
- グローバルメニュー（About, Preferences, Quit）はSwiftUIの`.commands`で再定義し、`CreateRigntClickMenu`の役割はSwiftUIの`Commands`＋`contextMenu`に集約。
- ステータスバーアイコンのクリックでメインウィンドウをトグルするロジックは、`@Environment(\.openWindow)`や`ScenePhase`を利用してSwiftUI的に再実装。
- 既存のショートカット（⌘R, ⌘[ など）を`FocusedValue`や`Commands`で割り当て、`WebViewRepresentable`のCoordinatorで`NSResponder`へ伝播。

#### フェーズ7: 移行テストとクリーンアップ
- 単体テスト：`TabSettingsStore`のCRUD、`WebTabViewModel`の状態遷移、設定保存／復元。
- UIテスト：主要シナリオ（タブ切り替え、ステータスバー操作、Preferences更新、リンク外部表示）。
- 段階的に旧AppKitコード・Storyboardリソースを削除し、SwiftUIベースの構成へ一本化。
- ドキュメント更新（README、開発手順、サポートOSバージョン）、CI/CDの再整備。

### リスクと対応策
- **WKWebViewの高度な操作**：SwiftUIラッパーだけでは不足する場合、必要な箇所に限定して`NSViewControllerRepresentable`を用いた再利用を検討し、徐々にCoordinatorへ移植。
- **ウィンドウサイズ制御**：SwiftUI標準APIで不足する場合、`NSWindow`参照を`WindowAccessor`ユーティリティで保持し、Combine経由でサイズを同期。
- **互換性確保**：MenuBarExtraなどOSバージョン依存APIはAvailabilityチェックを行い、fallbackとして既存AppKitの部品をSwiftUIアプリ内に残す。

### 成果物
- SwiftUIベースの`SquadApp`および関連Scene/View/ViewModel。
- `TabSettingsStore`・`WebTabViewModel`などの新しい状態管理コンポーネント。
- SwiftUIで実装されたメインウィンドウ、タブUI、設定画面、About・外部Webウィンドウ。
- 移行ガイドおよびテストスイートの整備。

### Testing
⚠️ テストコマンド未実行（リファクタリング計画の立案のみ）
