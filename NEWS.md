# kitDesign 0.2.0 (2026-10-31)

minor：新的函式與選項，舊的 app 不用改。

## 元件

* `kit_plotly_style()`：plotly 圖（例如 kits 的 `plot()`）套上 KIT 的樣子，和 app 看起來是一套。
  圓體字、`nb-ink` 字與軸線、`text-hint` 刻度、`line-soft` 格線、`line` 零線、白底、靠左的粗體標題
  （放不下時換行）、每一條軸（包括並排的小圖）、Okabe–Ito 的 `colorway`（plotly 的預設色換成同一個
  位置的 Okabe–Ito；指定的顏色不動）、熱圖換成 KIT 的色階、白底黑框的滑過說明框、圖例的位置
  （超過 4 項或太長、或圖寬小於 600px 時放到下面）、精簡的工具列（下載 PNG、放大、縮小、
  回到原來的範圍；沒有 plotly 的標誌；繁體中文）。只改樣子，不改資料。
  `legend = "keep"`、`colorscale = FALSE` 可以不換圖例位置、不換色階。
  和 kits、kitsUI 一起用的順序：kits 的 `plot()` → kitsUI 換色 → kitsUI 換中文 → `kit_plotly_style()`。
* `kit_plotly_fonts()`：plotly 圖附上 Google Fonts 的圓體（`data-external`，存成單一 HTML 時
  不把字型檔塞進去）；下載的 HTML 也是 app 的字型。`kit_plotly_style()` 預設已經附上。
* `kit_chart_sequential()`：連續數值的色階（極淡萊姆 `#f3f7d3` → `bg-new` → `nb-green`）。最小值不是白色，0% 和沒有施測的空格（白底）看得出來不同。
* plotly 與 htmlwidgets 是 Suggests：沒有用到 `kit_plotly_style()` 的 app 不用裝；沒有 plotly 時
  `kit_plotly_style()` 停下來，說要裝什麼。
* 元件樣張的「圖」分頁換成兩張套好樣子的 plotly 圖（各世代的線圖、題目 × 波次的熱圖）。

## 看得到的改變

* 危險按鈕（`kit_button(kind = "danger")`）是鮭魚色（`nb-salmon`）底、墨色字，滑過、按下時也是；
  之前小按鈕的白底蓋掉了它，看起來是白色的。停用的危險按鈕照停用的樣子。設計語言本來就這樣寫，
  所以這是修正；但畫面會變，升級時看一下有危險按鈕的頁面。
  `tools/check_gallery.R` 也檢查危險按鈕的顏色。

## 修正

* `kit_theme()`：bslib 比 0.11.0 舊（沒有 Brite 主題）時，先停下來說要更新 bslib，
  不再在 bslib 裡面出錯。
* `kit_new_app()` 的 README：用 `pak::pkg_install("<帳號>/<app>")` 或
  `remotes::install_github(..., upgrade = "always")` 安裝，太舊的套件（例如 bslib）會一起升級。

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
