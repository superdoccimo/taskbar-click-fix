# taskbar-click-fix クイックスタート

## 目的
Windows 11 で「タスクバーの短いクリックでアプリが前面に来ない」問題を、まず観測して、その後に補正MVPで改善するか確かめる。

## 必要なもの
- Windows 11 実機
- AutoHotkey v2
- このリポジトリ一式

## まず観測する
1. `ahk/taskbar_click_logger.ahk` を起動
2. タスクバーで短いクリックを 20〜30 回試す
3. 失敗した感覚があれば、そのまま続ける
4. 実行後に `taskbar_click_log.csv` を保存

## 次に補正を試す
1. logger を止める
2. `ahk/taskbar_click_fix_mvp.ahk` を起動
3. 同じように短いクリックを 20〜30 回試す
4. 改善したか、逆に違和感が出たか確認する

## 見るポイント
- 失敗回数が減ったか
- クリックが重く感じないか
- ドラッグっぽい違和感が増えていないか
- 同一アプリの複数ウィンドウ切り替えでも効くか

## 返してほしい情報
- Windows のビルド番号
- マウス/トラックボールの機種
- Bluetooth / Bolt など接続方式
- Logi Options+ の有無
- Windhawk / ExplorerPatcher の有無
- `taskbar_click_log.csv`
- 補正MVPの体感（良い / 微妙 / 悪化）

## もし補正が弱ければ
`ahk/taskbar_click_fix_mvp.ahk` のこの値を上げる:
- `MIN_HOLD_MS := 40`

候補:
- 50
- 60

## もし重く感じたら
`MIN_HOLD_MS` を下げる:
- 30
