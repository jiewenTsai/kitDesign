# KIT 設計語言

> 這一頁就是 kitDesign 裡的
> `brand/KIT設計語言.md`（以那一份為準）。元件的樣子見[元件一覽](https://jiewentsai.github.io/kitDesign/zh/articles/components.md)。

> **看得清楚、按得放心、結果先說。**

KIT 研究工具（kitJoin、kitsUI，以及之後的新 Shiny
app）共用的設計語言。新的 app
照這份做，使用者學會一個工具，其他工具也會用。

- **配套**：
  - 實作：R 套件
    **kitDesign**（[`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)、元件、模組、`inst/www/`
    的 CSS）。這份文件就在 kitDesign 的 `brand/`，以這一份為準。
  - 設計系統（即時樣張、tokens、標誌）：<https://claude.ai/artifact/GFN5Q5ie9jAHKwmsBaxb2M>
    （私人，要分享才看得到）
  - [\_brand.yml](https://github.com/jiewenTsai/kitDesign/blob/main/brand/_brand.yml)：顏色、字型等設計變數；[logo/](https://github.com/jiewenTsai/kitDesign/tree/main/brand/logo)：標誌（SVG、PNG）
  - 所有元件的樣子：[`kitDesign::kit_gallery()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_gallery.md)
- **狀態**：v1.1（2026-10-31）。v1.0 把 v0.2
  的「設計審查後的補充」併進正文；v1.1 加上 kitDesign 0.2.0
  的圖（[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)）、
  危險按鈕、熱圖色階、步驟卡的「前面只選、後面再細修」，以及「作者的決定」6–9。規格和程式不同時照程式寫，差異列在最後一節。

------------------------------------------------------------------------

## 為誰設計

|  |  |
|----|----|
| **誰** | 研究人員、研究助理，多半 40–60 歲；會用 SPSS、Excel，不一定會寫 R |
| **多久用一次** | 一年幾次，一次一兩個小時；每次回來都像第一次 |
| **在做什麼** | 處理真實的研究資料：串接、轉換、校準、評分。**結果錯了會跟著寫進論文** |
| **在哪裡用** | 研究室的桌機或筆電，螢幕 13–27 吋；偶爾用手機看結果 |
| **最怕什麼** | 不知道下一步按哪裡；按了不知道成功沒有；結果看起來成功但其實錯了 |

優先順序：**正確 \> 清楚 \>
好看**。好看是為了讓人願意用、看得舒服，不能犧牲前兩者。設計要簡單、乾淨。

## 七個原則

1.  **一頁一個主角。**
    每一頁只有一個主要按鈕（`nb-lime`），例如「開始校準」。其他東西都是配角，視覺上退後。
2.  **先結果、後細節。**
    按下去以後，第一眼是狀態框的一句結論、兩三個重點、一張表或一張圖。參數表、紀錄、檢查表、R
    程式碼收在細節列，要看再打開。
3.  **異常一定要被看見。**
    最危險的是「看起來成功其實錯了」。有需要人注意的事，狀態就不能是單純的【完成】。會改變結果的動作（跳過量尺、把代碼當遺漏值）由使用者自己按。
4.  **框就是一個單位。**
    有黑框的東西，代表可以操作，或是一個完整的單位（按鈕、輸入框、一個結果、一張圖）。框裡面不再有框，裝飾用的框一律不要。
5.  **安靜的配角。** 說明、提示、技術細節用 `hint` 字級、`text-hint`
    顏色、不加框，而且預設收起。第一次用的人找得到，熟手不會被擋住。
6.  **每一頁長得一樣。**
    同一套頁面骨架、同一組元件、同一套用詞。學會一頁就會用其他頁；學會
    kitJoin，kitsUI 也會用。
7.  **白話先行。**
    主要畫面用台灣常用的中文短句。英文術語（函式名、欄名）放在細節裡或下載的檔案裡。

## 視覺基礎

### 風格：克制的 neo-brutalism

保留三個特徵：黑框、零模糊的位移陰影、平塗色塊配黑字。為了中年使用者與長時間閱讀，全部調得克制：

| 一般的 neo-brutalism | KIT 的做法 | 理由 |
|----|----|----|
| 框 3–5px | `bw-frame` 2px | 和圓體字的筆畫相稱，看久不累 |
| 陰影 6–8px | `shadow-header` 4px、`shadow-card` 3px、`shadow-sm` 2px | 陰影只表示「可以按」或「一個結果」 |
| 大面積高彩度 | 高彩度只在頁首、主要按鈕、目前的步驟 | 大面積亮色看久了會累 |
| 刻意不對齊 | 對齊、規律的間距 | 工具要可預期 |

### 顏色

顏色依角色定義，每個角色只有一個顏色。

- **底**：整頁 `nb-page`（米白）；卡片、輸入框、表格、圖用
  `nb-card`。只有淺色，沒有深色模式。
- **墨**：所有文字、框、陰影都是 `nb-ink`。**色塊上的字一律用
  `nb-ink`**，不用白字。唯一的白字是主要資料表的黑色表頭。
- **主角**：`nb-lime`
  只用在頁首、主要按鈕、目前的分頁、目前步驟的編號、下拉的選取項。不要當文字色。
- **品牌與連結**：`nb-green`（和標誌深綠同一色）用在連結、進度條、✓、勾選框。滑過
  `nb-green-hover`。不要當大面積底色。
- **四個語意色**，看到顏色就知道意思：
  - `nb-mint` 完成
  - `nb-yellow` 要注意（也用在【要重新執行】）
  - `nb-salmon` 停下來（也用在危險按鈕）
  - `nb-sky` 資訊
- **顏色不能是唯一的訊號。**
  狀態框一定有文字標籤【完成】【完成，但請注意】【停下來】【要重新執行】；分頁的
  ✓、檢查清單的 ! 都有看不見的文字。
- **灰色只有這幾種**：
  - 配角文字 `text-hint`
  - 停用文字 `text-disabled`
  - 線 `line`、`line-soft`
  - 停用的框 `border-disabled`
- **強調文字**：「還差：…」用 `text-todo`；檢查清單的 ! 用
  `text-decide`；清單裡的單一問題用 `text-stop`。
- **標誌色**（`logo-bean`、`logo-leaf`）只用在標誌與插圖，不進介面。
- **圖**：類別色用色盲友善的 Okabe–Ito，依序取
  `chart-blue`、`chart-orange`、`chart-green`、`chart-purple`、`chart-sky`、`chart-vermillion`。參考線、帶子用
  `chart-neutral`；連續的值用 `chart-sequential`。

### 字型

- 全文一套圓體：**Chiron GoRound TC**（`sans`，Google Fonts，字重
  400、700、900）。
  - 層次靠字重和字級，不靠換字型。
  - 字重用 400 和 700；頁首 h1 可以到
    900。小按鈕與「沒問題」的檢查項目用 500。
- 程式碼、原始訊息、圖解裡的值：**JetBrains
  Mono**（`mono`），中文退回圓體。一律關掉連字（`font-variant-ligatures: none`），`<-`、`|>`
  照原樣顯示。
- 字級六級，基準 **17px**（`html { font-size: 17px }`）：
  - `display`：頁首 h1
  - `h4`：小節標題
  - `h5`：子標題、步驟卡標題、主要按鈕、狀態框第一行
  - `body`：內文
  - `small`：表格、步驟摘要
  - `hint`：提示、收合標題、組標籤、版本行
- 最小 `hint`（約 14px），更小只給圖表刻度。
- 中文與英文、數字之間加半形空格：「688 人」「依 SPSS
  數值標籤」。四位數以上加千分位：「3,389 人」。

### 框、陰影、圓角

- **框**：
  - 頂層元件用 `bw-frame`（2px）`nb-ink`。
  - 表格列分隔和小按鈕用 `bw-line`（1.5px）。
  - 圖解格線用 `bw-hair`（1px）。
- **圓角**：全部 `radius`（8px）；進度條 `radius-bar`；步驟編號
  `radius-round`。
- **陰影**，從大到小：
  - `shadow-header`：只有頁首。
  - `shadow-card`：結果，包括狀態框、圖、目前的步驟卡、主要按鈕。
  - `shadow-sm`：可以按的，包括分頁、一般按鈕、下拉選單、聚焦的輸入框。
  - 沒有陰影：提示框、程式碼、輸入框（沒聚焦時）、做完或還不能做的步驟卡、表格、小按鈕。提示框不是結果，所以沒有陰影，這樣狀態框永遠是頁面上最突出的盒子。
- **互動**：
  - 滑過時往右下移 1px，陰影變 `shadow-hover`。
  - 按下時移到底、沒有陰影，動畫 80ms。
  - 目前的分頁是「按下去」的樣子：萊姆色、沒有陰影、位移 2px。
  - 使用者設定「減少動態效果」時，不位移、不做動畫。
- **鍵盤焦點**：3px `focus` 外框、外推
  3px。分頁、檔案按鈕、勾選框都要有。

### 間距與版面

- 間距以 0.25rem 為一格，用 `sp-1`（0.25rem）到 `sp-5`（2.4rem）。
  - 小節之間 `sp-5`。
  - 同一小節的元件之間 `sp-3`。
  - 一排按鈕之間 `sp-2`。
- 內容最寬 `content-max`（1140px）置中；左右留 `gutter`，≤ `bp-tablet`
  時 1rem。
- 設定與結果並排時左 1/3、右 2/3；≤ `bp-tablet` 改上下排，設定在上。
- 表格寬度跟著內容，不拉滿；最寬到版面寬度，超過時在自己的框裡左右捲。

## 圖示

- 只用文字符號：
  - ✓：做完、沒問題
  - !：要決定
  - i：提醒
  - →：下一步、會離開這一頁
  - ▸／▾：收合
  - ↑↓：排序
  - ⬇：下載
  - ①–④：只用在有順序的流程分頁
- 不用 emoji，也不用其他圖示字型。
- 圖示一定配文字；文字旁的符號加 `aria-hidden="true"`。
- 同一個符號只有一個意思。

## 標誌

- 頁首用完整標誌 `kit-logo`（豆子＋KIT 字樣），高 5.6rem；手機
  3.6rem。瀏覽器分頁圖示只用豆子 `kit-mark`。
- 四周至少留標誌高度的 1/4。可以放在 `nb-lime`、`nb-page`、`nb-card`
  上；不要放在狀態色或 `nb-green` 上。
- 不要改顏色、比例，不要加框或陰影。旁邊已經有工具名稱時 `alt=""`。

## 元件

每個元件寫用途、對應的 R
函式、長相、規則、不要。即時樣張在設計系統的元件頁。

### 頁首（Header）

頁首告訴使用者這是哪個工具、哪一版；一個 app 只有一個，放在最上面。

- **R**：[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)（kit_theme.R），讀
  DESCRIPTION 的 Version、Date。
- **長相**：
  - `nb-lime` 色塊、`bw-frame` 框、`shadow-header`。
  - 左邊完整標誌（高
    5.6rem）；右邊工具名稱（`display`）、一行副標（粗體）、一行版本（`hint`）。
- **你要提供**：工具名稱（「KIT ×× 工具」）、副標（資料庫名稱 ·
  這個工具做什麼）。
- **規則**：
  - 版本行永遠在，回報問題時用得到。
  - 用其他資料測試時不改工具名稱。
  - 手機（≤ 576px）：標誌 3.6rem、h1 1.35rem。
- **不要**：在頁首放按鈕或導覽；改標誌的顏色、比例，或替標誌加框。

### 步驟分頁（NavTabs）

步驟分頁是工具裡的主要導覽：一排可以按的方塊，目前的萊姆色、做完的打
✓、還不能做的灰色。

- **兩種**：
  - **有順序的流程**（kitsUI）：① 資料 → ② 題目校準 → ③ 連結 → ④
    受試者評分，用圈數字。
  - **不是每一頁都要做**（kitJoin）：分三組、不編號，每組上面一行 `hint`
    組標籤：
    - 準備
    - 做出資料（選一個）
    - 其他工具
- **R**：kitsUI 用 `navset_tab` 加 `kit_tabs_js()` 的狀態；kitJoin 用
  [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroups.md)
  畫分頁列，真的分頁是 `tabsetPanel(type = "hidden")`，所以
  [`updateTabsetPanel()`](https://rdrr.io/pkg/shiny/man/updateTabsetPanel.html)
  照常可用。
- **長相**：
  - 白底、`bw-frame` 框、`shadow-sm`。
  - 目前的分頁 `nb-lime`、沒有陰影、往右下移 2px（被按下去的樣子）。
  - 獨立的小工具與「使用手冊」：虛線框、沒有陰影，放最右邊。
- **狀態**：
  - 做完：✓（`nb-green`），加看不見的「（已完成）」。
  - 還不能做：`bg-disabled` 底、`text-disabled`
    字，滑過時說明要先做什麼。
  - 要重新執行：✓ 拿掉。
- **規則**：
  - 分頁名稱用「名詞＋動詞」：檔案上傳、遺漏值處理。
  - ≤ 768px 時一排左右滑，不換行。
- **不要**：在分頁外面再加大框；用編號暗示每一步都要做，其實是擇一。

### 頁面說明（這一頁做什麼）（PageGuide）

「這一頁做什麼」是每個分頁最上面的一行說明，預設收起，第一次用的人打開看步驟。

- **R**：`kit_tab_guide(goal, steps, output, technical = NULL, note = NULL, diagram = NULL)`。
- **長相**：
  - 沒有框、`hint` 字級、`text-hint` 顏色，下面一條 `line` 淡線。
  - 「看步驟 ▸」是 `nb-green` 的底線字。
- **你要提供**：
  - `goal`：一句話，不超過 30 字。
  - `steps`：3–6 點。
  - `output`：會得到什麼。
  - 選填：`note` 補充、`technical`（再收一層）、`diagram`（見
    Diagram）。
- **不要**：預設打開；把設定或按鈕放進說明裡；寫成卡片。

### 按鈕（Button）

按鈕分四種，每一頁只有一個主要按鈕；文字用動詞開頭，說清楚按下去會發生什麼。

- **R**：`kit_button(id, label, kind = "secondary")`，`kind` 是
  `"primary"`、`"secondary"`、`"danger"`；一般按鈕就是
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  的預設樣子。
- **主要按鈕**（`btn-primary`）：
  - `nb-lime` 底、`h5` 字級、`shadow-card`，高度 ≥ 48px。
  - 一頁一個，加上最下面的「下一步」。
- **一般按鈕**（[`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  預設）：白底、`bw-frame` 框、`shadow-sm`，高度 ≥
  40px。用在「對，下一步」這類流程內的按鈕。
- **小按鈕**（`kind = "secondary"`，`btn-sm btn-outline-secondary`）：
  - 白底、`bw-line` 框、沒有陰影、0.85rem、字重 500，高度 ≥ 36px。
  - 用在下載、全選、範例檔、上移下移、複製。
- **危險按鈕**（`kind = "danger"`，`btn-sm btn-danger`）：
  - `nb-salmon` 底、`nb-ink` 字、`bw-line`
    框，大小和小按鈕一樣；滑過、按下時還是 `nb-salmon`。
  - 停用時照停用的樣子（`bg-disabled` 底），不是鮭魚色。
  - 用在刪除、移除、這一回合不做。
- **停用**：`bg-disabled` 底、`text-hint` 字、`border-disabled`
  框、沒有陰影，不用 opacity。停用的主要按鈕上面一定有「還差：…」（見
  ReadyLine）。
- **規則**：
  - 會離開這一頁的按鈕或連結，文字後面加「→」。
  - 建議的選項放第一個，寫「（建議）」。
  - 下載是這一頁的主角時（例如作答檔）用 `kit-download btn-primary`。
- **不要**：寫「確定」「送出」；一頁放兩個萊姆按鈕；用白字。

### 下載按鈕（DownloadButton）

下載按鈕和小按鈕長得一樣（⬇ 圖示＋「下載
CSV」），但檔名在每個瀏覽器都存得對，中文也一樣。

- **R**：`kit_download_button(session, id, label, filename, content, class = NULL)`，放在
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) 裡；
  測試裡按下載用 `kit_test_download(session, id)`。
- **長相**：`<a class="btn btn-default kit-download">`，小按鈕的樣子；是這一頁的主角時加
  `class = "btn-primary"`。
- **規則**：
  - 檔名在畫按鈕時決定；網址最後一段、`Content-Disposition`（`filename`
    與 UTF-8 的 `filename*`）、 `download` 屬性三處都是同一個檔名。
  - 檔案在按下載時才寫；寫不出來時跳出紅色通知（不會自己消失），[`kit_abort()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_abort.md)
    的白話原文照寫。
  - `.csv`、`.zip`、`.html` 用自己的 MIME，其他（`.sav`、`.csv.gz`）是
    `application/octet-stream`，瀏覽器不會多加副檔名。
  - app 在 `.onLoad()` 設一次 `options(kitDesign.app = "kitJoin")`：log
    寫哪個 app；檔名全是中文時， 舊瀏覽器用的 ASCII
    備用名是它的小寫（「第一波.sav」→「kitjoin.sav」）。
- **不要**：用
  [`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)（中文檔名在有些瀏覽器變成
  `missing-download_sav`）。

### 輸入元件（Input）

輸入元件是白底黑框，標籤在上、說明小字在下；預設值是最常用、最安全的那個。

- **R**：Shiny 原生的
  [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)、[`textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html)、[`radioButtons()`](https://rdrr.io/pkg/shiny/man/radioButtons.html)、[`checkboxInput()`](https://rdrr.io/pkg/shiny/man/checkboxInput.html)；說明用
  `.kit-hint`。
- **長相**：
  - 白底、`bw-frame` 框、`radius`。
  - 聚焦時出現 `shadow-sm`；下拉選單打開時，選到的項目是 `nb-lime`。
  - 勾選框、單選一律 20px，選取時 `nb-green`。
- **規則**：
  - 選項 2–5 個用單選圓鈕，一次全看得到；超過 5 個用下拉。
  - 必填就寫「（必填）」，不用紅色星號。
  - 進階選項收在「進階設定 ▸」（見 Details）。
  - 照欄名猜到的值用 `bg-guess` 淡黃底，提醒使用者看一遍。
  - **一格兩用**：同一欄有的檔案是「選檔案裡的一欄」，有的是「每一列都一樣的值」（世代
    TDCYP、波次 2009）。用一個可以打字的下拉選單，不要另外選模式。
  - 一組勾選框要有群組名稱；一排超過 8 個改成表格或「全選」。
- **不要**：輸入框加陰影（聚焦時以外）；在表格裡放沒有 `aria-label`
  的選單。

### 狀態框（StatusBox）

狀態框是按下主要按鈕以後第一眼要看的東西：固定四種標籤、顏色和用詞。

- **R**：[`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)、[`kit_done_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_done_status.md)（有
  warnings
  時自動變成要注意）、`kit_error_status(e, action, todo)`、`kit_stale_status(run_label)`；畫面用
  `make_status_ui()`。
- **四種狀態**：

| 狀態     | 標籤               | 底色        |
|----------|--------------------|-------------|
| 完成     | 【完成】           | `nb-mint`   |
| 要注意   | 【完成，但請注意】 | `nb-yellow` |
| 停下來   | 【停下來】         | `nb-salmon` |
| 需要重做 | 【要重新執行】     | `nb-yellow` |

- **長相**：`bw-frame` 框、`shadow-card`，是頁面上最突出的盒子。
- **內容**：
  - **第一行**：標籤＋一句結論，粗體、約 `h5`
    字級。例如「【完成】串接完成：結果共 3,389 列 × 2,058 欄。」
  - **接著**：最多 3
    點，要注意的事排在前、結果的重點排在後；其他收在「還有 N 點」。
  - **停下來時**：一定寫怎麼辦，附一個按鈕或連結；R
    的原文收在「原始訊息」。
- **規則**：
  - 執行完把狀態框捲到畫面上方（[`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_scroll_to.md)）。
  - 狀態框下面的重點是一張表或一張圖，不要再加「結果摘要」框。
- **不要**：自己發明新的標籤；把錯誤原文放在第一層。

### 提示框（Callout）

提示框是按下去之前就該知道的提醒，不是結果，所以沒有陰影。

- **R**：`kit_callout(..., warn = FALSE)`。雲端版的提醒是同一個樣子：頁首下面的橫幅
  [`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_cloud_banner.md)，
  頁面最下面的使用須知
  `kit_cloud_footer(sections, links)`（灰色小字，文字是 app
  的）；是不是雲端版用
  [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_is_cloud.md)。
- **兩種**：
  - **資訊**（`nb-sky`）：一般補充，例如「外部連結不適用：……這不是錯誤」。
  - **注意**（`warn = TRUE`，`nb-yellow`）：例如「資料裡有疑似遺漏值代碼，建議先到遺漏值處理」。
- **長相**：`bw-frame` 框、沒有陰影；框裡的連結是 `nb-ink` 粗體。
- **規則**：
  - 一個區塊最多一個提示框。
  - 能寫進狀態框的，就不要另外開提示框。
  - 有按鈕時，按鈕放在框外面。
- **不要**：用提示框報告結果；框裡再放框。

### 資料表（DataTable）

資料表是結果的主角之一：白底、黑表頭、寬度跟著內容；長表只顯示前幾列。

- **R**：`kit_static_table(df)`（整數自動加千分位）、`kit_preview_table(df, priority_cols, n)`、`kit_rows_note(nrow, ncol, shown_rows)`。
- **長相**：
  - 白底、`bw-frame` 外框、`nb-ink` 表頭白字。
  - 列之間 `bw-line` 細線、斑馬紋 `bg-stripe`、`small` 字級。
  - 數字靠右、等寬數字。
- **規則**：
  - 上面一個 `h4` 標題，加一行 `hint`：「共 157 列，以下前 20
    列。」完整的請下載，或放在「▸ 全部（157 列）」。
  - 寬度跟著內容，最寬到版面寬度；超過時在 `.kit-table-scroll`
    裡左右捲，不撐破版面。
  - **欄名**：函式的輸出與資料本身維持英文；app
    自己整理的摘要表可以用中文；下載的檔案維持原欄名。
  - 步驟卡裡的表不加外框，表頭用 `bg-stripe`（淡），不用黑表頭。
- **不要**：拉滿整頁；一次顯示幾百列。

### 圖（Chart）

圖放在白色卡片裡，一張圖只回答一個問題；類別色用
Okabe–Ito，依序取色。plotly 圖最後一定交給
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)，和
app 的其他部分看起來是一套。

- **R**：
  - 顏色：[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_colors.md)（類別色）、[`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_neutral.md)（中性色）、[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)（連續數值的色階）。
  - 樣子：`kit_plotly_style(p)`（plotly 是 Suggests，app 自己要
    `Imports: plotly`）；下載的單一 HTML 檔要 app 的字型：
    `kit_plotly_fonts(p)`（[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
    預設已經附上）。
  - kitsUI 的 `kit_chart.R`：`kit_chart_categorical()`（替 kits
    畫好的圖換類別色）、`kit_chart_role()`（角色色）。
- **和 kits 一起用的順序**：kits 的
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) → kitsUI
  換色（`kit_chart_categorical()`、`kit_chart_role()`）→
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)。kits
  畫的是什麼就是什麼，app 只套顏色與樣子。
  - 換色和
    [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
    的順序可以對調：它不動 kits 或 kitsUI 指定的顏色。
  - 畫面上和下載的 HTML 用同一個 reactive（套一次），兩邊一樣。

  ``` r

  p <- plot(x$item, type = "category", items = shown)          # kits
  p <- kit_chart_categorical(p)                                 # kitsUI
  kitDesign::kit_plotly_style(p, filename = "item_category")    # 最後
  ```
- **長相**（[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
  做的事）：
  - 卡片：`nb-card` 底、`bw-frame` 框、`shadow-card`（CSS 的
    `.js-plotly-plot`）；圖本身白底，下載的 PNG 也是白底。
  - 字：全部圓體（`sans`）、`nb-ink`；內文 15px，圖例與滑過的說明框
    14px，刻度 13px、`text-hint`。
  - 標題：靠左、粗體、約 `h5`（18px）；圖寬放不下時在瀏覽器端換行。kits
    的小標（`<sup>`）留在下一行。
  - 軸（每一條，包括並排的小圖）：軸線 `nb-ink`
    1.5px、只畫左邊與下面（不畫四邊的框）、刻度朝外、 格線
    `line-soft`、零線 `line`。只有一張圖時拿掉 kits
    的外框；並排的小圖（類別機率曲線、Wright map） 外框換成 `line`
    淡線，小圖之間還分得開。
  - 滑過的說明框：白底、`nb-ink` 框、圓體。
  - 圖例：沒有框；超過 4 項，或最長的一項超過 20 欄（中文字算 2
    欄），放在圖的下面、橫排、靠左； 其他放右邊。圖寬小於
    600px（手機）時一律放到下面。`legend = "keep"` 不動位置。
  - 色階：熱圖類換成
    [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)（極淡萊姆
    → `bg-new` → `nb-green`，值越大越深；最小值不用白色，0%
    和沒有資料的空格才分得開）； `colorscale = FALSE`
    保留原來的色階。色條的字、外框照上面的字級與顏色。
  - 工具列：沒有 plotly 的標誌；只有「下載成
    PNG」、放大、縮小、回到原來的範圍；繁體中文。
  - 邊界：上下左右一樣小；軸、圖例、色條放不下時自動加寬，軸標題與圖例離卡片的邊至少
    16px，不會切到字。
  - 不改：資料、軸的範圍與刻度、指定的顏色、點的形狀、線的粗細與虛線、hover
    與圖例的文字、圖的高度。
- **配色**：
  - 世代、量尺、分數依序取
    `chart-blue`、`chart-orange`、`chart-green`、`chart-purple`、`chart-sky`、`chart-vermillion`。
    plotly 自己給的預設色換成同一個位置的 Okabe–Ito。
  - 參考線、帶子、沒有判斷的點用 `chart-neutral`。
  - 連續的值（通過比例等）用 `chart-sequential`。
- **規則**：
  - 圖上方的標題就寫它回答的問題。
  - 圖上的字照 kits 的原文（英文），不翻譯：畫面、下載的圖和在 R 裡跑
    kits 得到的圖一樣，可以直接放進論文。
    使用者自己輸入的標籤（題號、領域、世代、波次、量尺名稱）照輸入的樣子顯示，中文也一樣。
  - 圖下面一行 `hint` 中文，說明怎麼讀；做決定要看的圖例（例如連結圖的
    Kept、Dropped），在說明裡寫出中文意思。
  - 圖和下面的說明之間至少留 1.2rem，說明不能壓到 x 軸。
  - 下載這張圖用小按鈕（HTML 用
    [`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)；工具列另外可以存
    PNG）。
- **不要**：用 plotly 的預設色或預設的工具列；在 app 裡另外改 plotly
  的字型與軸線；在一張圖裡回答兩個問題。

### 細節列、進階設定、設定摘要（Details）

細節列放「先結果、後細節」裡的細節：一排收起來的小字標題，打開的那一個佔一整行。

- **R**：`kit_details_row(...)` 包一排
  `kit_detail(title, ..., open = FALSE)`；設定區的進階選項用
  `kit_advanced(..., title = "進階設定")`；結果上面的一行設定摘要用
  `kit_settings_line(parts)`。
- **長相**：
  - 標題是 `text-hint` 小字加 ▸，沒有框。
  - 打開後內容也不加框；進階設定打開後左邊一條 `line` 淡線。
- **你要提供**：每個細節的標題（名詞：「題目參數」「這一回合的紀錄」「用
  R 怎麼做」）和內容。
- **規則**：
  - 預設收起。
  - 「用 R 怎麼做」永遠放在細節列的最後一個。
  - 設定摘要放在主要按鈕或結果上面，一行小字：「本回合 R1：M03、M36 ·
    參照世代 M03 · 沒有固定檔」。
- **不要**：用 accordion 卡片；細節裡再疊框。

### 用 R 怎麼做（CodePanel）

「用 R 怎麼做」把目前的設定寫成可以照著跑的 R 程式碼，永遠收在細節列裡。

- **R**：kitJoin 的
  `kit_code_blocks(snips)`、`kit_code_panel(output_id)`；kitsUI
  的同名元件。
- **長相**：
  - 收起時是細節列裡的一行小字「▸ 用 R 怎麼做」。
  - 打開後由上而下：
    1.  一行說明：「以下程式碼依你目前的設定產生，是簡化的示範。」
    2.  版本名稱（粗體）和「複製」小按鈕，在同一行。
    3.  程式碼。
  - 只有程式碼本身有框：`bg-code` 底、`bw-frame` 框、沒有陰影、`code`
    字級。
  - 程式碼框最寬到版面的內容寬度（左右留白以內），打開時不能撐破版面。
- **規則**：
  - 有兩個版本（tidyverse、base R）時，兩組「版本名稱＋程式碼」上下排。
  - 一律關掉連字：`<-`、`|>` 照原樣顯示，照著打才不會打錯。
  - **一行最多約 70 欄**：程式碼範例與說明都一樣，英文字母、數字、符號算
    1 欄，中文字算 2 欄。寫範本時就換行；顯示前
    [`kit_code()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code.md)
    自動用
    [`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_wrap.md)
    換行（在括號裡的逗號後面、註解在空白或中文字之間；換行前後 parse
    結果要一樣），[`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_cols.md)
    算每行幾欄；換行後還是太長的行（斷不開的長字串）會發出
    warning（不會停下來）。
  - 還是很長的程式碼在框裡左右捲，不換行。
- **不要**：預設打開；用卡片、圖示或綠色標頭；框裡疊框。

### 步驟卡（StepCard）

一頁裡有好幾步、而且有先後時用步驟卡：一次只打開一步，做完的收成一行。

- **R**：模組
  [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_stepcards_ui.md)／`kit_stepcards_server(id, titles, summaries, checks)`；低階
  [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_card.md)、
  [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_head.md)、[`kit_step_body()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_body.md)（kitJoin
  的「kits 作答檔」第 1–3
  步）。[`kit_steps()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_steps.md)
  是頁面說明裡的步驟清單，不是步驟卡。
- **三種狀態**：
  - **現在這一步**：白底、`bw-frame` 框、`shadow-card`；圓形編號
    `nb-lime`。
  - **做完的**：
    - 收成一行：圓形 ✓ `nb-mint`，後面一句摘要（例如「5 個檔案 · 世代
      TDCYP · 2009、2011（年）」），最右邊「改」。
    - 框 `border-disabled`、沒有陰影。
  - **還不能做的**：`border-disabled` 框、`text-disabled`
    字，寫「先完成第 1 步」。
- **規則**：
  - 按「對，下一步」（一般按鈕）才往下；做完的按「改」回去。
  - 主要按鈕在所有步驟下面，只有一個；上面一行「還差：…」（見
    ReadyLine）。
  - 卡片裡的表不加外框、淡表頭；手機上改成一列一塊（見 FileTable）。
  - 「改」的可以按範圍至少 32px，`aria-label` 寫「改第 N
    步：標題」；現在這一步加 `aria-current="step"`。
- **前面只選、後面再細修**：前面的步驟只做最少的選擇（例如第 2
  步只選「哪些欄是題目」）；細的設定放在後面的表裡改 （例如第 3
  步的題目表設定領域與計分）。前面那一步的說明要寫「之後在第 N
  步還能改」，使用者才不會以為一次要設好。
- **要改的表直接打開**：這一步的主角是一張要改的表（例如題目表）時，表直接顯示、不收在細節列裡；
  旁邊放「下載這張表」的小按鈕，任何時候都能下載。
- **不要**：一次打開好幾步；卡片裡再放卡片。

### 檢查清單（Checklist）

檢查清單把「要決定的事」和「已經沒問題的事」列在一起，放在轉換或執行之前。

- **長相**：一列一件事，左邊一個記號：
  - **!**（`text-decide`）：要決定。粗體一句話，下面一行小字說為什麼，再下面是決定的按鈕。
  - **✓**（`nb-green`）：沒問題，或已經決定。字重
    500；使用者自己決定的寫「（你選的）」，旁邊有「改回來」。
  - **i**（`text-hint`）：提醒，不用決定。
  - 列之間 `line-soft` 細線。
- **規則**：
  - 建議的選項放第一個，按鈕上寫「（建議）」。
  - 異常一定要按一下才算決定（疑似遺漏值代碼、資訊不足）；決定過的，結果的狀態框不再提醒一次。
  - 只列需要的事；逐題的表收在「▸ 逐題看、逐題改（45 欄）」，一頁 25
    列，可以搜尋。
  - 記號加
    `aria-hidden="true"`，前面放看不見的「要決定：」「沒問題：」「提醒：」。
- **不要**：把幾百題的逐題提醒都列出來。

### 還差什麼（ReadyLine）

主要按鈕還不能按時，按鈕上面一行寫還差什麼，並給一個去處理的連結。

- **R**：`kit_ready_line(missing, link = NULL)`；在 server 用
  `kit_run_gate(session, output, missing, link)`
  同時停用按鈕；檔案不夠時用 `kit_need_files(n_files, need = 2L)`。
- **長相**：一行 `text-todo` 粗體「還差：…」，後面接 `nb-green`
  連結「到「檔案上傳」加入檔案 →」；下面是停用的主要按鈕。
- **規則**：
  - 主要按鈕一開始就顯示（停用），讓人知道這一頁最後要按什麼。
  - 「還差」寫具體的事和數字：「至少要 2 個波次的檔案，目前只有 1 個。」
  - 伺服器端仍然要檢查，不能只靠按鈕停用。
- **不要**：把按鈕藏起來；用一個黃色提示框重複同一件事。

### 下一步（NextStep）

「下一步」在頁面最下面靠右，結果出來以後才出現，帶使用者到下一個分頁。

- **R**：`kit_next_step(text = NULL, button_id = NULL, label = NULL, button = NULL)`。
- **長相**：左邊一句 `hint`
  小字（可以是幾個去處的清單），右邊一個主要按鈕「下一步：××× →」。
- **規則**：
  - 出現的時機：狀態是【完成】或【完成，但請注意】。
  - 結果過期（【要重新執行】）時拿掉。
  - 按鈕文字寫出下一頁的名稱。
- **不要**：在結果還沒出來時顯示；放在頁面中間。

### 圖解（Diagram）

圖解用幾張小表畫出這一頁做的事（前 → 後），放在「這一頁做什麼」下面。

- **R**：`kit_diagram(before, after, caption, arrow = "→")`，表用
  `kit_dg_table(df, title, added = NULL)`。
- **長相**：
  - 配角：不加框、表格跟著內容寬、`bw-hair` 格線、`nb-page` 淡表頭。
  - 值用 `mono` 字型。
  - 新加的欄是 `bg-new` 底，欄名後面寫「（新）」，不只靠顏色。
  - 空的格子寫灰色的「（空）」。
- **規則**：
  - 每張小表 2–3
    列，用一般的名稱（id、score、wave），不用某個資料庫的欄名。
  - 下面一行 `hint` 白話說明。
  - ≤ 576px 時「前」在上、箭頭朝下、「後」在下。
- **不要**：用真實資料；用大資料表的黑表頭。

### 檔案表（FileTable）

檔案表是步驟卡或上傳頁裡「一列一個檔案、一欄一件事」的設定表；手機上每一列變成一塊。

- **R**：`table.table.kit-file-table`，每個 `<td>` 加
  `data-label`（欄名）；kitJoin 的上傳頁、kits 作答檔第 1 步，kitsUI
  的題庫選擇表。
- **長相**：
  - 桌機：一般表格，在步驟卡裡沒有外框、淡表頭。
  - ≤ 576px：表格和每一列都撐滿卡片寬度，每一列一塊，每格前面一行 `hint`
    欄名，列之間 `line` 分隔線。
- **規則**：
  - 每一列的按鈕位置固定：用不到的「上移」「下移」放看不見的佔位（`btn invisible`、`aria-hidden`），按鈕才不會左右跳。
  - 照欄名猜到的格子用 `bg-guess`。
  - 輸入框最寬到版面寬度。
- **不要**：在手機上讓整頁左右捲。

## 頁面骨架

每個分頁由上到下都是這個順序（一頁一個主要按鈕的分頁用
[`kit_run_tab_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_tab_ui.md)／[`kit_run_tab_server()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_tab_ui.md)，
固定的部分與狀態流都做好了，分頁只寫自己的設定、執行與結果）：

    頁首（一個 app 一個）
    步驟分頁（目前的萊姆色、做完的打 ✓、還不能做的灰色）
    這一頁做什麼：一句話                                      看步驟 ▸
    設定（左 1/3）               │ 設定摘要與預覽（右 2/3）
    進階設定 ▸
    還差：…（還不能按時）
    [ 主要按鈕 ]
    狀態框：【完成】一句結論＋最多 3 點
    重點：一張表（有 h4 標題）或一張圖
    ▸ 細節 1   ▸ 細節 2   ▸ 用 R 怎麼做
                                           [ 下一步：××× → ]

## 狀態流

    還不能做 ──(前一步完成)──▶ 可以做 ──(按主要按鈕)──▶ 執行中
           ┌───────────────┬───────────────┬────────────┘
           ▼               ▼               ▼
        【完成】  【完成，但請注意】    【停下來】
           └───────┬───────┘     (處理後重按，或按「這一回合不做」)
                   ▼
       「下一步」按鈕出現；分頁打 ✓
    （之後改了設定或檔案 →【要重新執行】，分頁的 ✓ 拿掉，後面的分頁變灰）

- 執行完把狀態框捲到畫面上方（減少動態效果時不要平滑捲動）。
- 預設顯示第一個成功的結果，不要預設選到停下來的那一個。
- 會改變結果的動作由使用者自己按，按鈕寫清楚後果（「這一回合不做（題庫與連結不會改變）」），做了要留紀錄。

## 手機（≤ 576px）

- 整頁不能左右捲動：`document.documentElement.scrollWidth`
  要等於視窗寬。輸入框、表格 `max-width: 100%`。
- 分頁一排左右滑，不要換行成好幾排。
- 卡片裡的表改成「一列一塊、欄名在上」（`data-label`）。
- 頁首縮小，第一屏看得到頁面說明和第一個設定。

## 文案

- 台灣繁體中文、短句、口語但不隨便；一句話只說一件事。主詞是「你」或省略，不寫「使用者」。
- 先說結論，再說原因：「這一回合資訊不足，無法估計：每個人在要估的題只剩一題。」
- 數字一定帶單位：「688 人」「3 個量尺」「2,058 欄」。
- 按鈕用動詞開頭，說清楚會發生什麼：「開始校準」「下載
  CSV」「到遺漏值處理頁改掉 →」，不寫「確定」「送出」。
- 錯誤訊息一定寫怎麼辦；R 的原文收在「▸ 原始訊息」。
- 建議的選項放第一個，按鈕上寫「（建議）」。
- 用詞表（同一件事只用一個詞）：

| 用這個       | 不用                       |
|--------------|----------------------------|
| 停下來       | 沒有完成、失敗、錯誤、中止 |
| 要注意       | 警告、warning              |
| 遺漏值       | 缺失值、missing            |
| 世代         | cohort（細節裡可以附英文） |
| 波次         | wave（細節裡可以附英文）   |
| 這一回合不做 | 略過、排除、skip           |

- 分頁名稱用「名詞＋動詞」：檔案上傳、遺漏值處理、資料串接、格式轉換。
- 表格欄名：函式的輸出與資料本身維持英文欄名；app
  自己整理的摘要表可以用中文；下載的檔案一律維持原欄名。

## 可及性檢查清單

`<html lang="zh-Hant-TW">`

內文 17px，最小字 14px

文字對比 ≥ 4.5:1；框、焦點框、圖形 ≥ 3:1

主要按鈕 ≥ 48px 高、一般按鈕 ≥ 40px、小按鈕 ≥ 36px、收合標題與文字連結 ≥
32px、勾選框 20px

鍵盤可以操作，焦點有 3px `focus` 框

狀態不只靠顏色，一定有文字

「減少動態效果」時沒有位移和動畫

程式碼關掉連字

390px 寬時整頁不能左右捲

## 在新的 Shiny app 使用

新的 app 不再複製檔案：載入 **kitDesign**
套件就好。主題、樣式（`inst/www/*.css`）、瀏覽器端的小程式（`inst/www/kit.js`）、標誌都在套件裡，每個
app 用的是同一份。

``` r

# 安裝
remotes::install_github("jiewenTsai/kitDesign")
```

在 app 套件的 DESCRIPTION 的 `Imports:` 寫 `kitDesign`。頁面這樣開始：

``` r

library(kitDesign)

ver <- kit_app_description("kitJoin")   # 讀 app 自己的 Version、Date
ui <- kit_page(
  "KIT ×× 工具", "臺灣幼兒發展調查資料庫",
  tagline = "這個工具做什麼",
  version = ver$version, date = ver$date,
  kit_navgroups(groups, "tabs"),          # 或 kit_flow_tabs(...)
  shiny::tabsetPanel(id = "tabs", type = "hidden", ...)
)
```

[`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)
已經設定好
`lang = "zh-Hant-TW"`、[`kit_theme()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_theme.md)、樣式與小程式（[`use_kit()`](https://jiewentsai.github.io/kitDesign/zh/reference/use_kit.md)）和頁首（[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)）。自己用
`bslib::page_*()` 組頁面時，放 `theme = kit_theme()` 和
[`use_kit()`](https://jiewentsai.github.io/kitDesign/zh/reference/use_kit.md)。開一個全新的
app：`kit_new_app(path, title, subtitle)`（頁首、步驟分頁、照頁面骨架寫好的範例分頁、測試都有）。

元件分三種：

- **值物件**（S3）：`kit_status`（狀態框）、`kit_check`／`kit_checklist`（檢查清單）、`kit_code`（一個版本的程式碼）。建構時檢查內容（例如狀態只能是
  idle／success／warning／error／stale），直接放進頁面或交給
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)
  就畫出來，[`print()`](https://rdrr.io/r/base/print.html) 印文字版。
- **模組**（有狀態的元件，`*_ui(id)` ＋ `*_server(id)`）：步驟分頁
  `kit_step_tabs_*`、步驟卡 `kit_stepcards_*`、主要按鈕＋還差
  `kit_run_gate_*`、用 R 怎麼做
  `kit_code_panel_*`。一頁一行，不用自己管狀態。
- **畫標記的函式**：其他元件，以及上面兩種的低階版（舊的 app
  可以慢慢換）。

每個元件用哪個函式：

| 元件 | 函式 |
|----|----|
| 頁首（Header） | [`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md) 已經放了；單獨用 [`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)、[`kit_app_meta()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_meta.md)；版本日期 [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_description.md) |
| 步驟分頁（NavTabs） | 模組 `kit_step_tabs_ui(id, ..., groups = )`／`kit_step_tabs_server(id, states, tips)`；低階：[`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroups.md)＋[`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroup.md)、`kit_flow_tabs(aside = )`、[`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_states.md)、[`kit_watch_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_watch_tab_states.md) |
| 頁面說明（PageGuide） | [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_guide.md)、[`kit_steps()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_steps.md) |
| 按鈕（Button） | `kit_button(id, label, kind)`、[`kit_btn_class()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_btn_class.md) |
| 下載按鈕（DownloadButton） | `kit_download_button(session, id, label, filename, content)`；測試 [`kit_test_download()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_test_download.md) |
| 狀態框（StatusBox） | 值物件 [`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)、[`kit_done_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_done_status.md)、[`kit_error_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_error_status.md)、[`kit_stale_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_stale_status.md)（直接放進頁面）；低階畫法 [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status_ui.md)；通知 [`kit_notify()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_notify.md)；白話錯誤 [`kit_abort()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_abort.md) |
| 提示框（Callout） | `kit_callout(..., warn = )`；雲端版橫幅 [`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_cloud_banner.md)、使用須知 [`kit_cloud_footer()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_cloud_footer.md)、判斷 [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_is_cloud.md) |
| 資料表（DataTable） | [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_static_table.md)、[`kit_preview_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_preview_table.md)、[`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_rows_note.md)、[`kit_table_scroll()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_table_scroll.md)、[`kit_num()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_num.md)、[`kit_dims()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_dims.md) |
| 圖（Chart） | [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)（plotly 圖的樣子）、[`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_fonts.md)；顏色 [`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_colors.md)、[`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_neutral.md)、[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md) |
| 細節列（Details） | [`kit_details_row()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_details_row.md)、[`kit_detail()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_detail.md)、[`kit_advanced()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_advanced.md)、[`kit_settings_line()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_settings_line.md) |
| 用 R 怎麼做（CodePanel） | 模組 [`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel_ui.md)／[`kit_code_panel_server()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel_ui.md)；值物件 `kit_code(code, label)`；換行 [`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_wrap.md)、行寬 [`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_cols.md)；低階 [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel.md)、[`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_render_code_panel.md)、[`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_blocks.md) |
| 步驟卡（StepCard） | 模組 [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_stepcards_ui.md)／`kit_stepcards_server(id, titles, summaries, checks)`；低階 [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_card.md)、[`kit_step_head()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_head.md)、[`kit_step_body()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_body.md) |
| 檢查清單（Checklist） | 值物件 [`kit_checklist()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_checklist.md)、`kit_check(state, title, why, actions)`；單一問題 [`kit_problems()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_problems.md) |
| 還差什麼（ReadyLine） | 模組 [`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_gate_ui.md)／`kit_run_gate_server(id, missing, link)`；低階 [`kit_ready_line()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_ready_line.md)、[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_gate.md)、[`kit_need_files()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_need_files.md) |
| 下一步（NextStep） | [`kit_next_step()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_next_step.md)；連到別的 app [`kit_app_link()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_link.md) |
| 圖解（Diagram） | [`kit_diagram()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_diagram.md)、[`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_dg_table.md) |
| 捲到結果、打開收合、離開前提醒 | [`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_scroll_to.md)、[`kit_open_details()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_open_details.md)、[`kit_unload_guard()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_unload_guard.md) |
| 頁面骨架＋狀態流（RunTab） | `kit_run_tab_ui(id, run_label, guide, ...)`／`kit_run_tab_server(input, output, session, run_label, run, done, ...)`：還差、設定摘要、執行、狀態框、通知、捲動、要重新執行、結果的細節、用 R 怎麼做 |

- 所有元件的樣子：[`kit_gallery()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_gallery.md)。
- 工具名稱維持「KIT ×× 工具」，用其他資料（例如 TDCYP）測試時也不改名。
- 版本行永遠在頁首，讀 app 自己的 DESCRIPTION 的 Version 與
  Date（[`kit_app_description()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_description.md)）；`show_kitdesign = TRUE`
  時後面接 kitDesign 的版本，回報問題時兩個版本都看得到。
- 版本規則與發布步驟見
  [版本與發布.md](https://jiewentsai.github.io/kitDesign/zh/articles/release.md)；kitJoin、kitsUI
  的舊名字見
  [遷移對照.md](https://github.com/jiewenTsai/kitDesign/blob/main/brand/%E9%81%B7%E7%A7%BB%E5%B0%8D%E7%85%A7.md)。
- 要新的元件或改樣式時，改 kitDesign（`inst/www/kit-design.css` 與
  `R/`），不要在 app 裡另外寫 CSS；只用本系統的
  tokens（顏色、`sp-*`、字級），寫之前先看有沒有現成的元件可以用。

### 換成別的品牌

kitDesign 預設是 KIT（萊姆頁首、KIT 綠、豆子標誌）。不是 KIT
的計畫也可以用：換**標誌**與**顏色**，
其他（字型、框、陰影、間距、元件、文案規則）照這份設計語言。kitDesign
0.3.0 起：

``` r

options(kitDesign.brand = kit_brand(
  "示範實驗室",
  logo = "logo.svg",     # 頁首的完整標誌（SVG 或 PNG）
  mark = "mark.svg",     # 瀏覽器分頁的圖示（方形；沒有給時用 logo）
  colors = list(accent = "#9cc0ff", primary = "#1f4fa3", page = "#f5f7fa")
))
```

- 設定一次，[`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)、[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)、[`kit_theme()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_theme.md)、[`kit_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_colors.md)、[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)、
  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)
  都用它；只給一頁時用 `kit_page(..., brand = )`。
- 可以換的顏色是下面附錄裡有 `--nb-*`
  變數的幾個（對照見附錄「顏色」表下面的說明）；沒有給的照 KIT。 只給
  `accent` 時 `accent_light` 自動算（和白色混合）；只給 `primary` 時
  `primary_hover` 自動算（加深）。
- 換顏色時照樣守這份文件的規則：色塊上的字一律 `ink`，所以 `accent`
  與四個狀態色上面放 `ink` 要有 4.5:1；`primary` 是連結文字，在 `page`
  上也要 4.5:1。四個狀態色最好不換，換的話意思不能變。
- 灰色（`text-hint`、`line`
  等）、焦點框、圖的類別色（Okabe–Ito）不跟著品牌換。
- 看換了以後的樣子：`kit_gallery(brand = "demo")`（藍色系的示範品牌）。

## 作者的決定（2026-10-31）

1.  **工具名稱**：維持「KIT」。TDCYP 只是測試用資料。
2.  **狀態標籤**：統一成【完成】【完成，但請注意】【停下來】【要重新執行】。
3.  **表格欄名**：函式的輸出與資料本身維持英文欄名；套件自己整理的摘要表可以用中文；下載的檔案維持原欄名。
4.  **kitJoin 的分頁**：分成三組、不編號（準備 · 做出資料（選一個）·
    其他工具）。
5.  **表格寬度**：跟著內容，不拉滿整頁。
6.  **圖上的字**：照 kits
    的原文（英文），不翻譯；使用者輸入的標籤照原樣（可以是中文）。app
    只套顏色與
    [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)。
7.  **危險按鈕**：鮭紅色（`nb-salmon`）、黑字。
8.  **熱圖色階**：最小值是極淡萊姆、不是白色，0%
    和沒有資料的格子分得開。
9.  **kits 作答檔**：第 2 步只選題目欄；領域、計分在第 3
    步的題目表設定；預設領域是題組名去掉結尾的 `_`、`.`、`-`。

## 和程式還不一致的地方

照程式寫進上面各節；要改程式或改規格時看這裡。

- **建議的選項**：v0.2
  提議用薄荷底按鈕，程式沒有做；現在只有「放第一個、文字寫（建議）」。
- **次要按鈕**：v0.2 第 9 節提議 2px 框加 2px 陰影；程式的
  `kit_button(kind = "secondary")`
  是小按鈕（1.5px、沒有陰影、0.85rem、字重 500）。帶陰影的白按鈕只有
  [`actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  的預設樣子。
- **字級**：規格是六級；`inst/www/kit-brite.css` 裡還有
  0.85、0.88、0.9、0.92、1.08rem 這些值，狀態框第一行是 1.08rem。
- **字重 500**：規格說只用 400 與 700，但小按鈕和「沒問題」的檢查項目用
  500。
- **舊的灰色**：`#4d4d4d`、`#6b6b6b`、`#9a9a9a`、`#c9c3b6` 還在
  `inst/www/kit-brite.css`
  的一些規則裡（大部分被後面的規則蓋掉）；還不能做的分頁底色是
  `#ece8dc`，不是 `bg-disabled`。

## 附錄：tokens

程式裡的 CSS 變數是 `--` 加上名稱，例如
`var(--nb-lime)`、`var(--sp-3)`。

### 顏色

| 名稱 | 值 | 用在 |
|----|----|----|
| `nb-ink` | `#141414` | 墨：所有文字、2px 框線、硬陰影、主要資料表的表頭底色。色塊上的字一律用它。 |
| `nb-page` | `#faf7f0` | 紙：整頁背景（米白）。nb-ink 在上面 17.2:1。 |
| `nb-card` | `#ffffff` | 卡：卡片、輸入框、表格、圖、按鈕（主要按鈕以外）的底色。 |
| `nb-lime` | `#c6d033` | KIT 萊姆，主角色：頁首、主要按鈕、目前的分頁與步驟編號、下拉選取。不要當文字色（在紙上只有 1.57:1）；上面放 nb-ink（10.9:1）。 |
| `nb-green` | `#006835` | KIT 綠（和標誌深綠同一色）：連結文字、進度條、✓ 記號、勾選框選取。在紙上 6.5:1、白底 6.9:1。不要當大面積底色或主要按鈕。 |
| `nb-green-hover` | `#004d27` | 連結滑過時的顏色。 |
| `nb-sky` | `#a8dcff` | 資訊：天藍提示框（kit_callout()）的底色，上面放 nb-ink。 |
| `nb-yellow` | `#ffde59` | 要注意：【完成，但請注意】【要重新執行】狀態框、注意提示框、雲端版橫幅。上面放 nb-ink。 |
| `nb-salmon` | `#ff9b8f` | 停下來：【停下來】狀態框、危險按鈕（刪除、這一回合不做）。上面放 nb-ink。 |
| `nb-mint` | `#b9f0a8` | 完成：【完成】狀態框、做完的步驟編號、上傳進度條的斜紋。上面放 nb-ink。 |
| `text-hint` | `#5a5a5a` | 配角文字：提示小字、說明、收合標題、組標籤、表格裡的次要資訊。在紙上 6.45:1、白底 6.9:1。 |
| `text-disabled` | `#6e6a60` | 停用文字：還不能做的步驟卡、還不能做的分頁、停用列。在紙上 5.0:1。 |
| `text-todo` | `#8a4a00` | 主要按鈕上面「還差：…」那一行、逐題表的提醒字（粗體）。在紙上 6.4:1。 |
| `text-decide` | `#a14a00` | 檢查清單「要決定」的 ! 記號。白底約 6.0:1。 |
| `text-stop` | `#8a2a00` | 表格或清單裡的單一問題（.kit-problems）。在紙上 8.1:1。 |
| `line` | `#d9d4c5` | 淡線：「這一頁做什麼」下緣、進階設定左邊的線、手機檔案表的分隔。只當線，不當文字。 |
| `line-soft` | `#e3ded2` | 最淡的線：檢查清單列之間、合成題號區塊上緣。 |
| `border-disabled` | `#8a8a8a` | 停用的框：還不能做或做完的步驟卡、停用的按鈕、還不能做的分頁。在紙上 3.2:1（框和圖形的門檻是 3:1）。 |
| `bg-disabled` | `#e8e4d8` | 停用按鈕的底色（不要用 opacity）；還不能做的分頁底色用相近的 \#ece8dc。 |
| `bg-stripe` | `#f3f0e6` | 資料表斑馬紋；步驟卡裡的淡表頭。 |
| `bg-soft-hover` | `#f1eee4` | 小按鈕滑過時的底色。 |
| `bg-code` | `#fffdf5` | 程式碼框的底色（加 2px nb-ink 框，沒有陰影）。 |
| `bg-guess` | `#fffbe6` | 照欄名猜出來的格子（淡黃），提醒使用者看一遍。 |
| `bg-new` | `#e8f0a0` | 圖解裡新加的欄（淡萊姆）；不用天藍，天藍是「資訊」。 |
| `focus` | `#0044ff` | 鍵盤焦點：3px 外框、外推 3px。黑框上看得到，紙上 6.0:1。 |
| `logo-bean` | `#aad05f` | 只用在標誌與插圖。不要當按鈕或底色（和萊姆只差 1.05:1）。 |
| `logo-leaf` | `#fff57f` | 只用在標誌與插圖。不要用在任何介面元件（和「要注意」的黃太像）。 |
| `chart-blue` | `#0072b2` | 圖的類別色第 1 個（Okabe–Ito）：世代、量尺、分數依序取色。 |
| `chart-orange` | `#e69f00` | 圖的類別色第 2 個。 |
| `chart-green` | `#009e73` | 圖的類別色第 3 個。 |
| `chart-purple` | `#cc79a7` | 圖的類別色第 4 個。 |
| `chart-sky` | `#56b4e9` | 圖的類別色第 5 個。 |
| `chart-vermillion` | `#d55e00` | 圖的類別色第 6 個；超過 6 類從頭再取。 |
| `chart-neutral` | `#7f7f7f` | 圖裡不分類別的中性色：參考線、帶子、沒有判斷的點。 |
| `chart-sequential` | `#f3f7d3` → `#e8f0a0` → `#006835` | 連續數值的色階（熱圖、色條）：極淡萊姆（不用白色：白色留給沒有資料的格子）→ 淡萊姆（`bg-new`，在 0.2）→ KIT 綠（`nb-green`），中間在 Lab 空間內插。[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)。 |

**品牌可以換的顏色**（`kit_brand(colors = )` 的名稱 → token → CSS
變數）： `ink` → `nb-ink`（`--nb-ink`）、`page` →
`nb-page`（`--nb-page`）、`card` → `nb-card`（`--nb-card`）、 `accent` →
`nb-lime`（`--nb-lime`）、`accent_light` → `bg-new`（`--nb-bg-new`）、
`primary` → `nb-green`（`--nb-green`）、`primary_hover` →
`nb-green-hover`（`--nb-green-hover`）、 `success` →
`nb-mint`、`warning` → `nb-yellow`、`danger` → `nb-salmon`、`info` →
`nb-sky`（都是 `--` 加上名稱）。 表裡的值是 KIT
的；別的品牌換掉這幾個，`chart-sequential` 跟著 `accent_light` 與
`primary` 算。 其他 token 不跟著品牌換。

### 字級（基準 17px）

| 名稱 | 大小 | 行高 | 字重 | 用在 |
|----|----|----|----|----|
| `display` | 1.75rem | 1.25 | 700 | 頁首 h1（工具名稱），一個 app 只有一個。手機（≤ 576px）縮成 1.35rem。 |
| `h4` | 1.35rem | 1.3 | 700 | 小節標題；上方留 2.4rem。標題要短，清單放下面的小字。 |
| `h5` | 1.1rem | 1.35 | 700 | 子標題、步驟卡標題、主要按鈕、狀態框第一行（狀態框第一行實作是 1.08rem）。 |
| `body` | 1rem | 1.65 | 400 | 內文、狀態框條列。html 基準字級 17px，所以 1rem = 17px。 |
| `small` | 0.95rem | 1.4 | 400 | 資料表（0.95rem）、步驟摘要與檢查清單說明（0.92rem）。 |
| `hint` | 0.82rem | 1.5 | 400 | 提示小字、收合標題、組標籤、版本行、圖解。最小字級，約 14px；更小只給圖表刻度。 |
| `code` | 0.85rem | 1.5 | 400 | 「用 R 怎麼做」、原始錯誤訊息、圖解裡的值。一律關掉連字，\<- 和 |

字型：`sans` = “Chiron GoRound TC”, sans-serif；`mono` = “JetBrains
Mono”, “Chiron GoRound TC”, Menlo, Consolas, monospace。

### 間距

| 名稱 | 值 | 用在 |
|----|----|----|
| `sp-1` | `0.25rem` | 圖示與文字之間。間距以 0.25rem 為一格。 |
| `sp-2` | `0.5rem` | 同一組元件之間，例如一排按鈕、分頁之間（0.5–0.6rem）。 |
| `sp-3` | `1rem` | 同一小節裡的元件之間、卡片內距、頁首上方。 |
| `sp-4` | `1.6rem` | 分頁組之間、「這一頁做什麼」到第一個設定、細節列上方。 |
| `sp-5` | `2.4rem` | 小節之間（h4 上方）、主要內容到「下一步」。 |
| `gutter` | `2rem` | 版面左右留白；≤ 768px 時改成 1rem。 |
| `content-max` | `1140px` | 內容最寬 1140px，置中；寬螢幕左右留白，不拉滿視窗。 |

### 圓角

| 名稱           | 值    | 用在                                                 |
|----------------|-------|------------------------------------------------------|
| `radius`       | `8px` | 全部的框：卡片、按鈕、輸入框、分頁、表格、圖、頁首。 |
| `radius-bar`   | `3px` | 只有上傳進度條。                                     |
| `radius-round` | `50%` | 步驟卡的圓形編號（2rem 見方）。                      |

### 陰影

| 名稱 | 值 | 用在 |
|----|----|----|
| `shadow-header` | `4px 4px 0 0 #141414` | 只有頁首。 |
| `shadow-card` | `3px 3px 0 0 #141414` | 結果：狀態框、圖、目前的步驟卡、主要按鈕。 |
| `shadow-sm` | `2px 2px 0 0 #141414` | 可以按的：分頁、一般按鈕（actionButton 預設）、下拉選單、輸入框聚焦。 |
| `shadow-hover` | `1px 1px 0 0 #141414` | 按鈕、分頁滑過時：往右下移 1px（主要按鈕移 2px），陰影剩 1px；按下時移到底、沒有陰影。 |

### 框的粗細

| 名稱 | 值 | 用在 |
|----|----|----|
| `bw-frame` | `2px` | 所有頂層元件的框：卡片、按鈕、輸入框、分頁、表格外框、程式碼框。 |
| `bw-line` | `1.5px` | 表格列分隔、小按鈕的框、說明區下緣。 |
| `bw-hair` | `1px` | 圖解小表的格線、上傳進度條外框、檢查清單列之間。 |

### 斷點

| 名稱 | 值 | 用在 |
|----|----|----|
| `bp-phone` | `576px` | ≤ 576px：頁首變小、檔案表一列一塊、圖解改上下排、主要動作優先。 |
| `bp-tablet` | `768px` | ≤ 768px：左右留白 1rem、分頁一排左右滑、步驟卡內容不縮排、設定與結果改上下排。 |
