# Changelog

## kitDesign 0.7.0 (2026-11-01)

minor：新的互動資料表與範圍選擇列（給 kitItemBank）；純粹加東西，app
不用改，現有元件的樣子與行為都不變。

### 元件

- `kit_dt(df, selection, page_length, search, wrap_cols, min_widths, ordering, options, ...)`：互動資料表
  （DT），放在
  [`DT::renderDT()`](https://rdrr.io/pkg/DT/man/dataTableOutput.html)
  裡，給要搜尋、換頁、點選的表（題目清單、搜尋結果）。和
  [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_static_table.md)
  同一個樣子：2px 框、黑表頭白字、斑馬紋、列之間的線、`small`
  字級、數字欄自動靠右（等寬數字）。 選到的列是淡萊姆、左邊一條 KIT
  綠，不是藍色；可以點選的表滑過時變淡、游標是手指。 文字是中文（「共 37
  列，第 1–20
  列」「上一頁」「下一頁」「沒有符合的資料」）；換頁按鈕長得像小按鈕 （≥
  36px、目前這一頁萊姆色），手機上只留上一頁、目前這一頁、下一頁。`page_length = 0`
  是全部顯示、不分頁； `wrap_cols`
  的欄換行，其他欄不換行。寬的表在自己的框裡左右捲，手機上整頁不左右捲。
  表頭與換頁按鈕可以用鍵盤到，焦點是藍框。DT 是 Suggests：用到的 app 要
  `Imports: DT`。
- `kit_scope_bar(input, line, actions, panel)`：範圍選擇列。全 app
  共用的一個選擇（例如用哪一份題庫），
  放在分頁列正下方、不加框：單選圓鈕、一行
  hint、右邊的小按鈕，以及選了以後要確認的內容。
- 新的 CSS class（只作用在新的 class 上，不碰現有的元件）：
  - `table.kit-dt`、`.kit-dt-selectable`、`.kit-dt-nowrap`、`.kit-dt-wrap`，以及
    [`kit_dt()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_dt.md)
    包在表外面的
    `.kit-dt-box`、`.kit-dt-top`、`.kit-dt-scroll`、`.kit-dt-foot`；
  - `.kit-scopebar`、`.kit-scopebar-line`、`.kit-scopebar-actions`、`.kit-scopebar-todo`、`.kit-scopebar-panel`；
  - `.kit-buttons`：一排按鈕（一般按鈕＋小按鈕），間距
    `sp-2`，放不下就換行。
- 設計語言 v1.2：資料表（DataTable）加上「結果的表用
  [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_static_table.md)、要操作的表用
  [`kit_dt()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_dt.md)」；
  新的一節「範圍選擇列（ScopeBar）」。
- 元件樣張（[`kit_gallery()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_gallery.md)）多了「互動表與範圍」分頁。

### 看得到的改變

- 沒有：現有的元件、函式、頁面一模一樣（`tools/check_gallery.R`
  每個分頁的截圖和 0.6.0 比過：只有版本行不同）。

### 修正

- 收合區塊（[`kit_detail()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_detail.md)、[`kit_advanced()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_advanced.md)
  等所有 `<details>`）裡的 htmlwidget（plotly、DT、visNetwork）：
  打開時，`kit.js` 先通知 Shiny 裡面的 output
  看得到了，等版面排好（下一個畫面）再讓圖重新量大小， 300ms
  後再量一次（接住打開以後才畫好的
  output）。以前是同一刻就量，收起來時已經畫成細細一條的圖，
  打開後有時還是細細一條。畫面不變。
- `tools/check_gallery.R`：比的是
  `clientWidth`（視窗寬減掉直捲軸），有直捲軸的系統上不會誤報「左右捲」。

## kitDesign 0.6.1 (2026-11-01)

### 修正

- 收起來的
  `<details>`（[`kit_detail()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_detail.md)
  等）裡面的東西不排版（`display: none`）。新的 Chrome、Firefox
  收起來時只是看不到，裡面的元素還有寬高，Shiny 就以為裡面的圖看得到，在
  76px 寬的框裡畫 plotly： 圖畫壞（打開後擠成一條），還跳「axis
  scaling」的錯，連帶擋住同一頁其他畫面的更新（kitsUI 按「用這一回合的
  固定檔開始下一回合」後 ① 沒有更新）。現在收起來時 Shiny
  知道它藏著，打開才畫，寬度也對。

## kitDesign 0.6.0 (2026-11-01)

minor：圖的工具列可以下載投稿用的圖；app 不用改。

### 元件

- [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
  的工具列：
  - 「下載 PNG」一律 2100 像素寬（7 吋、300
    dpi；長寬比照畫面，不受視窗大小影響），檔案裡寫 300 dpi： 插進 Word
    預設就是 7 吋寬（雙欄論文的寬度），投稿系統讀到的也是 300
    dpi。以前是畫面大小的 2 倍、沒寫 dpi。
  - 新的「下載 SVG」：向量圖，給要 600 dpi 以上、EPS 或 PDF 的期刊（用
    Inkscape、Illustrator 轉）。
    文字只記字型名稱，用打開它的電腦裡有的字型（圓體是網頁字型，沒裝的電腦會換成系統字型）。
  - 兩個都在瀏覽器裡做，不經過 R、不增加伺服器負擔；下載的單一 HTML
    檔裡也能用。存檔不經過頁面上的連結，外掛攔不到。

## kitDesign 0.5.2 (2026-11-01)

### 修正

- Firefox 裝了某些外掛（例如 Google PDF Viewer
  這類「線上檢視文件」的外掛）時，下載還是 Not Found：
  外掛會攔截頁面上的下載連結，自己把頁面導到下載網址。現在
  [`kit_download_button()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_download_button.md)
  是 `<button data-kit-href data-kit-download>`，不是
  `<a href download>`：按鈕上沒有連結，外掛攔不到； 按下去由 `kit.js`
  在背景拿檔案再存檔（存檔的連結不放進頁面，外掛也看不到）。
  畫面不變；app 的測試若讀按鈕的 `href`、`download` 屬性，改讀
  `data-kit-href`、`data-kit-download`。

## kitDesign 0.5.1 (2026-11-01)

### 修正

- Firefox：按下載按鈕時會跳出「離開前提醒」，按「離開」後頁面真的離開、連線斷掉，下載變成
  Not Found。現在下載不離開頁面：`kit.js` 在背景用 `fetch()`
  拿檔案，再直接存檔（所有瀏覽器都一樣）。
  下載中按鈕變淡、不能重複按（`.kit-downloading`）。
- [`?kitDesign`](https://jiewentsai.github.io/kitDesign/zh/reference/kitDesign-package.md)
  與所有函式的說明改成英文（R 裡的說明、英文網站）。中文說明放在
  `pkgdown/zh/man/`，中文網站照用。

## kitDesign 0.5.0 (2026-11-01)

minor：版本行可以寫 app 的名稱；現有的 app 不用改，畫面也不會變。

### 元件

- [`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)、[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)、[`kit_app_meta()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_meta.md)
  多了 `package`：app 的套件名稱寫在版本行最前面， 「kitsUI v0.5.0 ·
  2026-10-31 · kits 0.25.2」。回報問題時一看就知道是哪個 app 的哪一版。
  預設 `NULL`：不寫名稱，和以前一樣。

## kitDesign 0.4.0 (2026-10-31)

minor：kitJoin 與 kitsUI 各有一份的機制搬進 kitDesign；舊的 app
不用改，兩個 app 的畫面與下載的檔案一模一樣。

### 元件

- 檔案的小工具（原本 kitJoin、kitsUI
  各一份一模一樣的）：[`kit_fix_utf8_chr()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_files.md)、[`kit_fix_utf8_df()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_files.md)、
  [`kit_is_valid_utf8_df()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_files.md)、[`kit_sav_safe_names()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_files.md)、[`kit_truncate_bytes()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_files.md)、[`kit_gz_path()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_files.md)、[`kit_open_browser()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_files.md)。
- `kit_download_button(session, id, label, filename, content, class, app)`：下載按鈕（從兩個
  app 的 `R/download.R`
  搬過來）。中文檔名在每個瀏覽器都存得對：網址最後一段、`Content-Disposition`
  （`filename` 與 UTF-8 的 `filename*`）、`<a download>`
  都是同一個檔名。`.csv`、`.zip`、`.html` 用自己的 MIME，其他是
  `application/octet-stream`。寫檔出錯時寫 log、跳出紅色通知、回 500。
  `app`（預設 `getOption("kitDesign.app", "kit")`）是 log 裡的 app
  名稱，也是全中文檔名的 ASCII 備用名（小寫）；app 在 `.onLoad()`
  設一次。
- `kit_test_download(session, id, write = TRUE)`：[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
  裡按下載，回傳 `httpResponse` 和檔名。
- [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_is_cloud.md)：是不是雲端版（`KIT_DEPLOY`，沒有時看
  `R_CONFIG_ACTIVE = "rsconnect"`）。
- `kit_cloud_footer(sections, links, title, id)`：雲端版使用須知（頁尾的灰色小字）；
  每一段的段名與內文、參考連結由 app
  給。[`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_cloud_banner.md)
  搬到同一個檔（`R/cloud.R`）。
- [`kit_run_tab_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_tab_ui.md)／[`kit_run_tab_server()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_tab_ui.md)：執行分頁的骨架（kitJoin
  的六個分頁都是這個樣子）。 UI 照頁面骨架排：這一頁做什麼 →
  分頁自己的設定（`...`）→ 設定摘要 → 還差 → 主要按鈕 → 狀態框 → 重點 →
  下載 → 細節列（結果的細節、用 R 怎麼做）→ 下一步。server 在分頁的
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html)
  裡呼叫， 做好狀態流：還差與停用、設定摘要、按下去（`guard()` →
  進度條裡 `run()` → `done(result)`，出錯是 `error(e)`）→
  狀態框、通知、捲到狀態框；改了設定（`stale_on()`）→【要重新執行】；結果的重點、
  細節與「用 R
  怎麼做」。要使用者確認的錯誤（`confirm`）跳出視窗、不通知。回傳
  `result`、`status`、 `state`、`run(...)`。不是 Shiny 模組：設定的
  input 留在分頁自己的 namespace，id 不變
  （`<tab>-run`、`<tab>-status`、`<tab>-code`…）。

## kitDesign 0.3.0 (2026-10-31)

minor：新的函式與選項，舊的 app 不用改；KIT 的畫面一模一樣。

### 元件

- [`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)：品牌物件（S3），標誌與顏色不再寫死，不是
  KIT 的計畫也能用。
  `kit_brand(name, logo, mark, logo_alt, colors)`：`logo`
  是頁首的標誌、`mark` 是瀏覽器分頁的 圖示（SVG 或
  PNG；檔案在建立時讀進來）；`colors` 用設計語言的名稱換顏色：
  `ink`、`page`、`card`、`accent`（`--nb-lime`）、`accent_light`（`--nb-bg-new`）、
  `primary`（`--nb-green`）、`primary_hover`（`--nb-green-hover`）、`success`（`--nb-mint`）、
  `warning`（`--nb-yellow`）、`danger`（`--nb-salmon`）、`info`（`--nb-sky`）。
  不認得的名稱會停下來，列出可以用的名稱。不給參數就是 KIT。
- [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_current_brand.md)：`options(kitDesign.brand = kit_brand(...))`
  設定一次，所有函式都用它； 沒有設定時是 KIT。
- [`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)、[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)、[`kit_theme()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_theme.md)、[`kit_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_colors.md)、[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)、
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
  多一個 `brand =` 參數（預設
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_current_brand.md)）：
  - 頁首的標誌、替代文字、分頁圖示從品牌來；自己的標誌檔在 Shiny
    裡由一個只有這些檔的 htmlDependency 提供，`logo = "inline"` 時寫成
    data URI。
  - 顏色和 KIT 不同時，頁首多一小段
    `<style>html:root { --nb-…: … }</style>`；bslib 主題的
    `primary`、`link-color`、`body-bg`、`border-color` 也換。KIT
    的品牌不放這一段。
  - 熱圖的色階從品牌來（淡端是 `accent_light` 的極淡色，中間在 Lab
    空間內插到 `primary`）； 類別色（Okabe–Ito）不換，維持色盲友善。
- `kit_gallery(brand = "demo")`：用藍色系的示範品牌看所有元件；`tools/check_gallery.R`
  的第三個參數 `demo` 也是。示範的標誌在 `inst/examples/brand/`。
- [`kit_new_app()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_new_app.md)
  的 README 多一個 `brand =` 的例子。

### 樣式

- `inst/www/` 的 CSS 不再寫死 KIT 的品牌色：`kit-base.css` 與
  `kit-brite.css` 改用 `--nb-*` 變數； `kit-brite.css` 的 `:root`
  多兩個變數：`--nb-green-hover`、`--nb-bg-new`。KIT
  的值不變，畫面不變。

### 修正

- [`kit_theme()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_theme.md)
  不再讀工作目錄或上層資料夾的 `_brand.yml`（bslib 0.9 起 `bs_theme()`
  會自己找， 例如 `brand/_brand.yml`）：品牌只從
  [`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)
  來。沒有 `_brand.yml` 的地方（部署的 app） 主題一模一樣；開發時旁邊有
  `_brand.yml` 的話，以前會被它改掉字型與顏色。

### 開發

- 網站（pkgdown，`_pkgdown.yml`、`pkgdown/extra.css`、`vignettes/articles/`）：首頁、開始使用、
  元件一覽（元件直接畫在頁面上，旁邊是程式碼）、圖、換成別的品牌、設計語言、版本與發布、函式參考
  （照元件分組）、更新紀錄。`.github/workflows/pkgdown.yaml` 會在 push
  到 main 時建好網站、 放到 `gh-pages` 分支；`docs/` 不進
  git。本機：[`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)。

## kitDesign 0.2.0 (2026-10-31)

minor：新的函式與選項，舊的 app 不用改。

### 元件

- [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)：plotly
  圖（例如 kits 的
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html)）套上 KIT
  的樣子，和 app 看起來是一套。 圓體字、`nb-ink` 字與軸線、`text-hint`
  刻度、`line-soft` 格線、`line` 零線、白底、靠左的粗體標題
  （放不下時換行）、每一條軸（包括並排的小圖）、Okabe–Ito 的
  `colorway`（plotly 的預設色換成同一個 位置的
  Okabe–Ito；指定的顏色不動）、熱圖換成 KIT
  的色階、白底黑框的滑過說明框、圖例的位置 （超過 4 項或太長、或圖寬小於
  600px 時放到下面）、精簡的工具列（下載 PNG、放大、縮小、
  回到原來的範圍；沒有 plotly 的標誌；繁體中文）。只改樣子，不改資料。
  `legend = "keep"`、`colorscale = FALSE` 可以不換圖例位置、不換色階。
  和 kits、kitsUI 一起用的順序：kits 的
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) → kitsUI 換色
  → kitsUI 換中文 →
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)。
- [`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_fonts.md)：plotly
  圖附上 Google Fonts 的圓體（`data-external`，存成單一 HTML 時
  不把字型檔塞進去）；下載的 HTML 也是 app
  的字型。[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
  預設已經附上。
- [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)：連續數值的色階（極淡萊姆
  `#f3f7d3` → `bg-new` → `nb-green`）。最小值不是白色，0%
  和沒有施測的空格（白底）看得出來不同。
- plotly 與 htmlwidgets 是 Suggests：沒有用到
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
  的 app 不用裝；沒有 plotly 時
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
  停下來，說要裝什麼。
- 元件樣張的「圖」分頁換成兩張套好樣子的 plotly 圖（各世代的線圖、題目 ×
  波次的熱圖）。

### 看得到的改變

- 危險按鈕（`kit_button(kind = "danger")`）是鮭魚色（`nb-salmon`）底、墨色字，滑過、按下時也是；
  之前小按鈕的白底蓋掉了它，看起來是白色的。停用的危險按鈕照停用的樣子。設計語言本來就這樣寫，
  所以這是修正；但畫面會變，升級時看一下有危險按鈕的頁面。
  `tools/check_gallery.R` 也檢查危險按鈕的顏色。

### 修正

- [`kit_theme()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_theme.md)：bslib
  比 0.11.0 舊（沒有 Brite 主題）時，先停下來說要更新 bslib， 不再在
  bslib 裡面出錯。
- [`kit_new_app()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_new_app.md)
  的 README：用 `pak::pkg_install("<帳號>/<app>")` 或
  `remotes::install_github(..., upgrade = "always")`
  安裝，太舊的套件（例如 bslib）會一起升級。

## kitDesign 0.1.0 (2026-10-31)

第一版：把 kitJoin 0.5.0 與 kitsUI 0.4.0 各自的介面合成一個套件（phase
1）。 兩個 app 還沒有改用它（phase 2、3）；名稱對照見
`brand/遷移對照.md`。

### 設定

- [`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)、[`kit_theme()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_theme.md)、[`use_kit()`](https://jiewentsai.github.io/kitDesign/zh/reference/use_kit.md)、[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)、[`kit_app_meta()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_meta.md)、
  [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_description.md)、[`kit_versions()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_versions.md)、[`kit_logo_uri()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_logo_uri.md)、[`kit_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_colors.md)。
- 樣式從 R 字串搬到
  `inst/www/`（`kit-base.css`、`kit-brite.css`、`kit-design.css`），
  小程式在 `inst/www/kit.js`；畫面和 kitJoin 0.5.0、kitsUI 0.4.0 一樣。
- 頁首的版本行可以接上 kitDesign 的版本（`show_kitdesign = TRUE`）。

### 元件

- 頁面說明、按鈕、提示框、細節列、進階設定、設定摘要、還差、下一步、圖解、資料表、
  步驟卡、檢查清單、步驟分頁（流程與分組兩種）、圖的顏色。
- 值物件：`kit_status`、`kit_check`／`kit_checklist`、`kit_code`（有
  `as.tags()`、
  [`format()`](https://rdrr.io/r/base/format.html)、[`print()`](https://rdrr.io/r/base/print.html)；建構時檢查內容）。
- 模組：`kit_stepcards_*`、`kit_step_tabs_*`、`kit_run_gate_*`、`kit_code_panel_*`。
- 「用 R 怎麼做」每行最多 70
  欄：[`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_wrap.md)、[`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_cols.md)（演算法來自
  kitJoin）。

### 修正

- 「用 R
  怎麼做」打開時，很長的一行程式碼不再把版面撐寬（`.kit-details > .kit-detail`
  加上 `min-width: 0`）。

### 開發

- [`kit_new_app()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_new_app.md)：開一個新的
  KIT app 套件骨架。
- [`kit_gallery()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_gallery.md)：所有元件的樣張
  app。
- [`vignette("kitDesign")`](https://jiewentsai.github.io/kitDesign/zh/articles/kitDesign.md)：一步一步做一頁。
