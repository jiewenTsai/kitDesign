# Package index

## 設定與頁面

一個 app 一次：主題、樣式、頁首、版本。

- [`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
  : KIT 的頁面：主題、樣式、頁首，一次設定好
- [`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)
  : KIT 的 bslib 主題
- [`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md)
  : KIT 的樣式與瀏覽器端小程式（htmltools 的 dependency）
- [`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md)
  : KIT 頁首
- [`kit_app_meta()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_meta.md)
  : 頁首的版本行，例如「v0.5.0 · 2026-10-31」
- [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_description.md)
  : 讀取 app 的版本與日期（DESCRIPTION 的 Version、Date）
- [`kit_versions()`](https://jiewentsai.github.io/kitDesign/reference/kit_versions.md)
  : 版本：kitDesign 與 app 自己的
- [`kit_logo_uri()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_uri.md)
  : KIT 標誌（data URI）
- [`kit_logo_file()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_file.md)
  : 標誌檔的網址（頁面上用）
- [`kit_logo_dependency()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_dependency.md)
  : 標誌檔（inst/logo/）的 htmlDependency：頁首的 SVG
  與分頁圖示用網址取得
- [`kit_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_colors.md)
  : KIT 品牌色常數（供自訂 CSS 或圖表使用）
- [`kit_new_app()`](https://jiewentsai.github.io/kitDesign/reference/kit_new_app.md)
  : 開一個新的 KIT Shiny app
- [`kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md)
  : 元件樣張 app

## 品牌

換成別的計畫的標誌與顏色。

- [`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)
  : 品牌：標誌與顏色

- [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)
  :

  現在的品牌：`options(kitDesign.brand = )`，沒有設定時是 KIT

## 步驟分頁（NavTabs）

- [`kit_step_tabs_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  [`kit_step_tabs_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  : 步驟分頁模組（NavTabs）

- [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md)
  : 分組的分頁列（不編號；kitJoin 的樣子）

- [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroup.md)
  :

  分頁列的一組（給
  [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md)）

- [`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/reference/kit_flow_tabs.md)
  : 有順序的流程分頁（kitsUI 的樣子）

- [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md)
  : 每個分頁的狀態

- [`kit_watch_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_watch_tab_states.md)
  : 分頁狀態一變就送到瀏覽器

- [`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_send_tab_states.md)
  : 把分頁狀態送到瀏覽器

## 頁面說明（PageGuide）

- [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md)
  : 頁面說明：這一頁做什麼（PageGuide）

- [`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md)
  :

  編號的步驟清單（放在
  [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md)
  的 `steps`）

## 狀態框（StatusBox）

- [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  [`as.tags(`*`<kit_status>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  [`format(`*`<kit_status>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  [`print(`*`<kit_status>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  : 狀態物件（StatusBox）

- [`kit_done_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_done_status.md)
  : 執行完的狀態：有要注意的事時是【完成，但請注意】，否則是【完成】

- [`kit_error_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_error_status.md)
  : 執行失敗的狀態（【停下來】）

- [`kit_stale_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_stale_status.md)
  : 檔案或設定變更後，舊結果失效（【要重新執行】）

- [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md)
  : 狀態框（StatusBox）

- [`kit_notify()`](https://jiewentsai.github.io/kitDesign/reference/kit_notify.md)
  : 顯示通知（Shiny 的 showNotification）

- [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
  : 給使用者看的錯誤

- [`kit_is_user_error()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_user_error.md)
  :

  是不是
  [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
  丟出的錯誤

## 按鈕（Button）

- [`kit_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_button.md)
  : 按鈕（Button）
- [`kit_btn_class()`](https://jiewentsai.github.io/kitDesign/reference/kit_btn_class.md)
  : 按鈕種類的 class

## 下載按鈕（DownloadButton）

- [`kit_download_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_download_button.md)
  : 下載按鈕（DownloadButton）
- [`kit_test_download()`](https://jiewentsai.github.io/kitDesign/reference/kit_test_download.md)
  : 測試裡按下載按鈕

## 檔案的小工具

編碼、SPSS 變項名稱、壓縮檔路徑、開啟瀏覽器。

- [`kit_fix_utf8_chr()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_fix_utf8_df()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_is_valid_utf8_df()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_sav_safe_names()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_truncate_bytes()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_gz_path()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_open_browser()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  : 檔案的小工具：編碼、SPSS 變項名稱、壓縮檔路徑、開啟瀏覽器

## 提示框（Callout）

- [`kit_callout()`](https://jiewentsai.github.io/kitDesign/reference/kit_callout.md)
  : 提示框（Callout）
- [`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md)
  : 雲端版的提醒橫幅（頁首下面一行）
- [`kit_cloud_footer()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_footer.md)
  : 雲端版使用須知（頁面最下面，灰色小字）
- [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_cloud.md)
  : 是不是雲端版

## 資料表（DataTable）

- [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md)
  : 小表格（直接放在 renderUI() 裡，不用另開 output）

- [`kit_preview_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_preview_table.md)
  :

  預覽表的資料（交給
  [`shiny::renderTable()`](https://rdrr.io/pkg/shiny/man/renderTable.html)）

- [`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/reference/kit_rows_note.md)
  : 長表的說明：「共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。」

- [`kit_table_scroll()`](https://jiewentsai.github.io/kitDesign/reference/kit_table_scroll.md)
  : 寬的表放在這裡面：在自己的框裡左右捲，不撐破版面

- [`kit_num()`](https://jiewentsai.github.io/kitDesign/reference/kit_num.md)
  : 整數加千分位

- [`kit_dims()`](https://jiewentsai.github.io/kitDesign/reference/kit_dims.md)
  : 維度描述：「5 列 × 7 欄」

## 圖（Chart）

- [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
  : plotly 圖套上 KIT 的樣子（Chart）
- [`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_fonts.md)
  : plotly 圖附上 app 的字型（下載的 HTML 用）
- [`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md)
  : 圖的類別色（Chart）
- [`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md)
  : 圖裡不分類別的中性色
- [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)
  : 連續數值的色階（Chart）

## 細節列（Details）

- [`kit_details_row()`](https://jiewentsai.github.io/kitDesign/reference/kit_details_row.md)
  : 一排細節（Details）
- [`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md)
  : 一個細節：預設收起，標題一行小字
- [`kit_advanced()`](https://jiewentsai.github.io/kitDesign/reference/kit_advanced.md)
  : 進階設定：預設收起
- [`kit_settings_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_settings_line.md)
  : 設定摘要：主要按鈕或結果上面一行小字

## 用 R 怎麼做（CodePanel）

- [`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  [`kit_code_panel_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  : 「用 R 怎麼做」模組（CodePanel）

- [`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  [`as.tags(`*`<kit_code>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  [`format(`*`<kit_code>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  [`print(`*`<kit_code>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  : 一個版本的程式碼（CodePanel）

- [`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md)
  : 把一段程式碼換行成每行最多 70 欄

- [`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_cols.md)
  : 每行的顯示寬度（中日韓字、全形字算 2 欄）

- [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)
  : 「用 R 怎麼做」的位置（CodePanel）

- [`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md)
  :

  server 端：把程式碼畫進
  [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)

- [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md)
  : 「用 R 怎麼做」的內容：說明＋一個或幾個版本的程式碼（附「複製」）

## 步驟卡（StepCard）

- [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  [`kit_stepcards_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  : 步驟卡模組（StepCard）
- [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md)
  : 步驟卡（StepCard）
- [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md)
  : 步驟卡的標頭
- [`kit_step_body()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_body.md)
  : 步驟卡的內容

## 檢查清單（Checklist）

- [`kit_checklist()`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  [`as.tags(`*`<kit_checklist>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  [`format(`*`<kit_checklist>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  [`print(`*`<kit_checklist>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  : 檢查清單（Checklist）
- [`kit_check()`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  [`as.tags(`*`<kit_check>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  [`format(`*`<kit_check>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  [`print(`*`<kit_check>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  : 檢查清單的一列（Checklist）
- [`kit_problems()`](https://jiewentsai.github.io/kitDesign/reference/kit_problems.md)
  : 表格或清單裡的問題（深橘紅的字）

## 還差什麼（ReadyLine）

- [`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  [`kit_run_gate_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  : 主要按鈕＋「還差：…」模組（ReadyLine）
- [`kit_ready_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_ready_line.md)
  : 還差什麼（ReadyLine）
- [`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md)
  : 主要按鈕還不能按時：停用它，上面一行寫還差什麼
- [`kit_need_files()`](https://jiewentsai.github.io/kitDesign/reference/kit_need_files.md)
  : 「還差」：檔案不夠時的那一句

## 下一步（NextStep）

- [`kit_next_step()`](https://jiewentsai.github.io/kitDesign/reference/kit_next_step.md)
  : 下一步（NextStep）
- [`kit_app_link()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_link.md)
  : 連到別的網站或 app 的連結（開新分頁）

## 圖解（Diagram）

- [`kit_diagram()`](https://jiewentsai.github.io/kitDesign/reference/kit_diagram.md)
  : 圖解：處理前的小表 → 處理後的小表，下面一行白話說明（Diagram）
- [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_dg_table.md)
  : 圖解用的小表格（2–3 欄、2–4 列）

## 執行分頁（RunTab）

一頁一個主要按鈕的分頁骨架：頁面骨架的順序與狀態流。

- [`kit_run_tab_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_tab_ui.md)
  [`kit_run_tab_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_tab_ui.md)
  : 執行分頁（RunTab）

## 模組

有狀態的元件：`*_ui(id)` ＋ `*_server(id)`，一頁一行。

- [`kit_step_tabs_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  [`kit_step_tabs_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  : 步驟分頁模組（NavTabs）
- [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  [`kit_stepcards_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  : 步驟卡模組（StepCard）
- [`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  [`kit_run_gate_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  : 主要按鈕＋「還差：…」模組（ReadyLine）
- [`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  [`kit_code_panel_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  : 「用 R 怎麼做」模組（CodePanel）

## 頁面行為

捲到結果、打開收合、離開前提醒。

- [`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md)
  : 執行完把狀態框捲到畫面上方
- [`kit_open_details()`](https://jiewentsai.github.io/kitDesign/reference/kit_open_details.md)
  : 打開一個收合區塊（例如套用預設後打開進階設定）
- [`kit_unload_guard()`](https://jiewentsai.github.io/kitDesign/reference/kit_unload_guard.md)
  : 離開頁面前的提醒
