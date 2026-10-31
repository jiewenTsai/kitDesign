# kitDesign 0.1.0 (2026-10-31)

第一版：把 kitJoin 0.5.0 與 kitsUI 0.4.0 各自的介面合成一個套件（phase 1）。
兩個 app 還沒有改用它（phase 2、3）；名稱對照見 `brand/遷移對照.md`。

## 設定

* `kit_page()`、`kit_theme()`、`use_kit()`、`kit_header()`、`kit_app_meta()`、
  `kit_app_description()`、`kit_versions()`、`kit_logo_uri()`、`kit_colors()`。
* 樣式從 R 字串搬到 `inst/www/`（`kit-base.css`、`kit-brite.css`、`kit-design.css`），
  小程式在 `inst/www/kit.js`；畫面和 kitJoin 0.5.0、kitsUI 0.4.0 一樣。
* 頁首的版本行可以接上 kitDesign 的版本（`show_kitdesign = TRUE`）。

## 元件

* 頁面說明、按鈕、提示框、細節列、進階設定、設定摘要、還差、下一步、圖解、資料表、
  步驟卡、檢查清單、步驟分頁（流程與分組兩種）、圖的顏色。
* 值物件：`kit_status`、`kit_check`／`kit_checklist`、`kit_code`（有 `as.tags()`、
  `format()`、`print()`；建構時檢查內容）。
* 模組：`kit_stepcards_*`、`kit_step_tabs_*`、`kit_run_gate_*`、`kit_code_panel_*`。
* 「用 R 怎麼做」每行最多 70 欄：`kit_code_wrap()`、`kit_code_cols()`（演算法來自 kitJoin）。

## 修正

* 「用 R 怎麼做」打開時，很長的一行程式碼不再把版面撐寬（`.kit-details > .kit-detail`
  加上 `min-width: 0`）。

## 開發

* `kit_new_app()`：開一個新的 KIT app 套件骨架。
* `kit_gallery()`：所有元件的樣張 app。
* `vignette("kitDesign")`：一步一步做一頁。
