# 套件開發須知

> 這一頁就是 kitDesign 裡的 `brand/套件開發須知.md`（以那一份為準）。

KIT 的 R
套件（kits、kitDesign、kitsUI、kitJoin、kitverse，以及之後的新套件）共用的規則：
套件怎麼放、版本怎麼升、NEWS 怎麼寫、Shiny app
怎麼做、統計計算怎麼寫才可信。
版本規則與發布步驟的細節在[版本與發布](https://jiewentsai.github.io/kitDesign/zh/articles/release.md)；介面的規格在
[KIT
設計語言](https://jiewentsai.github.io/kitDesign/zh/articles/design-language.md)。

| 套件            | 種類                    | 這份文件的哪幾節 |
|-----------------|-------------------------|------------------|
| kits            | 統計計算                | 一、二、四       |
| kitDesign       | 介面（給 app 用的元件） | 一、二           |
| kitsUI、kitJoin | Shiny app               | 一、二、三       |
| kitverse        | 一次裝好、載入其他套件  | 一、二           |

------------------------------------------------------------------------

## 一、每個套件都要有的

### 1. 檔案

| 檔案 | 內容 |
|----|----|
| `DESCRIPTION` | `Version`、`Date`、`Authors@R`、`URL`（GitHub 與網站）、`BugReports`、`Encoding: UTF-8`、`Depends: R (>= 4.1.0)`、`Imports`（寫最低版本）、`Remotes`（不在 CRAN 的套件，指到 tag） |
| `NAMESPACE`、`man/` | 由 roxygen2 產生，不手改 |
| `R/` | 程式碼。字串只用 ASCII（見第 4 點） |
| `tests/testthat/` | 測試。每個修好的 bug 都留一個測試 |
| `README.md` | 英文（GitHub 預設顯示）；`README.zh-TW.md` 是中文。兩份第一行互相連結 |
| `NEWS.md` | 每一版改了什麼（見第二節） |
| `LICENSE`、`LICENSE.md` | MIT |
| `.github/workflows/` | R CMD check（Linux、Windows、macOS）；有網站的再加 pkgdown |

### 2. 相依套件

- **`Imports` 一定寫最低版本**，特別是用到新功能的時候，例如
  `bslib (>= 0.11.0)`（Brite 主題）。
  [`install.packages()`](https://rdrr.io/r/utils/install.packages.html)
  只裝沒有的套件，不會升級已經裝了但太舊的；有寫最低版本， kitverse 與
  app 的啟動腳本才查得出來、才會升級。
- **`Remotes` 指到 tag，不跟著 main**：`jiewenTsai/kitDesign@v0.5.0`。
- **同一個套件，所有地方要指到同一個 tag。** kitsUI 寫
  `kitDesign@v0.5.0`、kitverse 寫 `kitDesign`（main）時， pak
  會停在「dependency conflict」，三個平台的 CI 都失敗。升 kitDesign
  時，kitsUI、kitJoin、kitverse 一起改。
- 能不加的相依就不加。只在少數函式用到的套件放 `Suggests`，用的時候
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html)。

### 3. 安裝的來源

- 學員從 **r-universe**（<https://jiewentsai.r-universe.dev>）裝：像
  CRAN 一樣，有 Windows、macOS 編好的版本， 不用 Rtools、Xcode，也不經過
  GitHub API。
- **工作坊不要用 `remotes::install_github()`**：80
  人在同一個會場（同一個對外 IP）時，GitHub 每小時 60 次的 API
  限制會用完，`pak` 也一樣。
- 新套件要放上 r-universe：在 `jiewenTsai/jiewentsai.r-universe.dev` 的
  `packages.json` 加一行， 並在 GitHub 的 r-universe App 設定裡勾選那個
  repo。

### 4. 中文與編碼

- 檔案一律 UTF-8。
- **R 程式碼的字串只能用 ASCII**（R CMD check 的規定），中文寫成
  `\uXXXX`。寫的時候直接寫中文， 改完跑
  `LC_ALL=en_US.UTF-8 Rscript tools/escape_non_ascii.R`：它會換成
  `\uXXXX`，並在上一行留一行 「`# 原文：…`」。註解、roxygen
  說明、測試可以直接寫中文。
- Windows 上 R 4.2 起才全面用 UTF-8：中文檔名、中文欄名要求 R 4.2
  以上（kitverse 會檢查）。

### 5. 測試與檢查

- `R CMD check`：0 錯誤、0 警告。NOTE 要能解釋（例如 kitverse 故意不
  import 它的 Imports）。
- 測試不要寫死會變的東西：日期、版本號從 `DESCRIPTION` 讀。
- 修 bug 先寫一個會失敗的測試，再修。
- 會讓 R 當掉的情況（例如 readr 讀到奇怪的編碼），在 `callr`
  的子程序裡測，當掉也只是那個測試失敗。

### 6. Git

- 一個 commit 做一件事。訊息第一行寫做了什麼，內文寫為什麼、怎麼驗證的。
- 升版本的 commit 標題寫版本：「kitJoin 0.7.0: 「KIT 資料處理工具」,
  kitDesign 0.5.0」。
- 發布打 tag：`vX.Y.Z`。
- **不 commit 資料**：TDCYP
  等研究資料只在自己的電腦上測試，測完刪掉；測試用的資料用假資料或公開的示範資料。

------------------------------------------------------------------------

## 二、版本號與 NEWS

### 1. 版本號（X.Y.Z）

| 改了什麼 | 升哪一位 | 例子 |
|----|----|----|
| 修正：畫面、函式、結果都沒變 | **patch**（0.6.0 → 0.6.1） | 修 JavaScript、修說明、修測試 |
| 新功能，或畫面看得到的小改變；現有的使用方式不用改 | **minor**（0.6.1 → 0.7.0） | 加一個函式、加一個有預設值的參數、app 改標題、加一張圖 |
| 現有的使用方式要改 | **major**（0.7.0 → 1.0.0） | 函式改名或刪掉、參數意思變了、檔案格式（例如固定檔）讀不到舊的、**計算結果變了** |

- **0.x 的意思是「還在調整」**；1.0.0 是承諾：從這一版起，上表的 major
  改變都要升主版本，並寫清楚怎麼遷移。
- kitDesign：看得到的設計改變（顏色、按鈕大小）算 major，因為兩個 app
  都會跟著變（見[版本與發布](https://jiewentsai.github.io/kitDesign/zh/articles/release.md)）。
- 統計計算套件：**同一份資料算出不同的數字，至少是
  minor**；改的是估計方法或預設值時是 major。NEWS 要寫差多少。
- 什麼時候 1.0：
  - kitDesign：兩個 app 都用的第一版（條件已經達到）。
  - kitsUI、kitJoin、kitverse：工作坊當天用的版本。80
    個人裝的是同一版，回報問題時大家講的是同一個版本。
  - kits：固定檔格式、函式名稱定案，結果交叉驗證過（見第四節）。

### 2. NEWS.md

每個套件一份，放在 repo 的根目錄。在 R 裡用 `news(package = "kitsUI")`
看；pkgdown 網站的「更新紀錄」就是它。

``` markdown
# kitJoin 0.7.0 (2026-11-01)

## Changes you can see

* The app is now called 「KIT 資料處理工具」 ...

## Fixes

* ...

## Under the hood

* Uses kitDesign 0.5.0 (`Imports: kitDesign (>= 0.5.0)`, `Remotes: jiewenTsai/kitDesign@v0.5.0`).
```

- 標題一定是 `# 套件 X.Y.Z (YYYY-MM-DD)`（pkgdown 靠它分版本）。
- 小標題用這幾個，沒有的就不寫：
  - **Breaking changes**：要怎麼改才能繼續用（major 才有）。
  - **Changes you can see**：使用者看得到的：畫面、函式、輸出的檔案。
  - **Fixes**：修了什麼；錯的結果被當成成功的，要特別寫出來。
  - **Under the hood**：使用者看不到的：相依套件、重構、測試。
- 寫給使用者看：說「現在會怎樣」，不是「改了哪個檔」。畫面上的字照原樣寫，例如「③
  各世代的垂直連結」。
- 一版一節，新的在最上面。不要把歷史寫在 README（README
  只放一行「每一版的改變見 NEWS.md」）。
- kitDesign 的 NEWS
  用中文小標題（元件、修正、看得到的改變），意思和上面一樣。

### 3. 發布一版

1.  改 `DESCRIPTION` 的 `Version`、`Date`。
2.  在 `NEWS.md` 最上面加這一版。
3.  檢查：`tools/escape_non_ascii.R`、`roxygen2::roxygenise()`、`R CMD build`、`R CMD check`（0
    錯誤、0 警告）。
4.  commit、`git tag vX.Y.Z`、推上
    GitHub（`git push origin main --tags`）。r-universe 會自己重編。
5.  用到它的套件跟著改：`Imports` 的最低版本、`Remotes` 的
    tag，並在它們的 NEWS 寫「Uses kitDesign X.Y.Z」。 kitverse 的
    `Imports` 也要跟著升。

------------------------------------------------------------------------

## 三、Shiny app

### 1. 做成套件

- app 是一個 R 套件：`run_xxx()` 開
  app（`run_kitsui()`、`run_kitjoin()`），`kit_app()` 回傳 `shinyApp`。
- 根目錄的 `app.R`
  給雲端部署用（[`source()`](https://rdrr.io/r/base/source.html) 套件的
  `R/`），`run.bat` 給 Windows 本機雙擊用。三種方式都讀同一份
  `DESCRIPTION` 的版本。
- 新 app 用
  [`kitDesign::kit_new_app()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_new_app.md)
  開骨架：頁首、步驟分頁、照頁面骨架寫好的範例分頁、測試都有了。

### 2. 介面一律用 kitDesign

- 頁面：`kit_page(title, subtitle, version = , date = , package = "kitXxx")`。版本行就是
  「kitXxx v0.7.0 · 2026-11-01」，回報問題時一看就知道是哪個 app
  的哪一版。
- 元件、顏色、字型、狀態框、按鈕都用 kitDesign 的，不要自己複製一份 CSS
  或主題。 缺什麼元件，加進 kitDesign，兩個 app 一起用。
- 規格照 [KIT
  設計語言](https://jiewentsai.github.io/kitDesign/zh/articles/design-language.md)：給
  40–60 歲的研究人員，看得清楚、按得放心、結果先說；
  一頁一個主要按鈕；執行後捲到狀態框；「用 R 怎麼做」寫出等效的 R
  程式碼。
- 畫面上的字用繁體中文、白話；圖上的字照 kits 的英文。

### 3. 雲端部署（Posit Connect Cloud）

- `manifest.json` 記錄雲端要裝哪些套件、哪個版本。**升 kitDesign
  後一定要更新**，不然雲端會裝到舊版，app 一打開就壞。
- **不要整個重新產生**：`rsconnect::writeManifest()` 會把所有 CRAN
  套件一起升到最新（曾經一次升了 17 個，包括出過問題的 readr）。
  只換要換的那一項（例如 kitDesign）和改過的檔案的檢查碼，並看 diff
  確認。
- **一個雲端 app 撐不住整場工作坊。** 壓力測試（2026-10-31）：kitsUI 在
  Free（4 GB、1 CPU）20 人就到 2.6–2.8 GB、 50 人當掉；Basic（8 GB、2
  CPU）100 人撐得住，但最慢的人要等 30 分鐘以上。R 是單執行緒，加 CPU
  幫助不大。 80–100 人的工作坊，每個人用自己的電腦（kitverse）。

### 4. 本機版

- 學員裝
  kitverse：[`library(kitverse)`](https://rdrr.io/r/base/library.html)
  後用 `run_kitsui()`、`run_kitjoin()`。
- `kitverse_check()` 會真的把每個 app 開起來試，新 app 要加進它的清單。
- 上傳的資料只在學員自己的電腦上，不會傳到任何伺服器。

### 5. 測試

- 伺服器邏輯用
  [`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)；下載用
  [`kitDesign::kit_test_download()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_test_download.md)。
- 版本行、標題這類畫面上的字，測試用規則比對（`"kitJoin v[0-9.]+ · "`），不要寫死版本號。
- 改了流程，至少用真的資料從頭跑一次（不要只靠單元測試）。

------------------------------------------------------------------------

## 四、統計計算套件

統計計算的錯誤常常不會當掉，而是**安靜地算出錯的數字**。所以規則的重點是：算的是什麼要寫清楚、
算得對要驗證過、結果變了要說出來。可以參考 rOpenSci 的
[統計軟體標準](https://stats-devguide.ropensci.org/)（一般標準，加上
IRT、迴歸、貝氏等各類的標準）。

### 1. 寫清楚算的是什麼

- 每個方法寫出模型、估計法與參考文獻（DOI）：`DESCRIPTION` 的
  Description、函式說明， 以及可以在 R 裡查的地方（kits 的
  `kits_algorithm()` 會列出一個結果背後的步驟、公式與文獻）。
- 預設值寫出為什麼這樣設（例如收斂標準、最大迭代次數、遺漏值怎麼處理）。
- 提供 `inst/CITATION`（kits 已經有），`citation("kits")`
  可以查到怎麼引用。

### 2. 計算和呈現分開

- 計算層是純函式：輸入資料與設定，輸出結果，不讀寫檔案、不印東西、不依賴全域選項
  （kits 的 `algo_*()` 這一層，可以用 pipe 串起來）。
- 結果是有 class 的物件，有
  [`print()`](https://rdrr.io/r/base/print.html)、[`summary()`](https://rdrr.io/r/base/summary.html)、[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html)、[`plot()`](https://rdrr.io/r/graphics/plot.default.html)。
- Shiny app 只呼叫計算層，不在 app 裡重寫計算。「用 R
  怎麼做」寫出的程式碼要能算出一模一樣的結果。

### 3. 輸入檢查與錯誤

- 進入計算前先檢查：欄位、型別、範圍（例如分數要從 0
  開始）、遺漏值、每一類有沒有足夠的人。
- 錯誤、警告用有 class 的 condition，使用者可以用
  [`tryCatch()`](https://rdrr.io/r/base/conditions.html) 依類別接（kits
  的 `kits_abort(..., class = "kits_error_data")`， 不用另外依賴
  rlang）。訊息說出哪裡錯、怎麼修；app 再把它翻成白話（kitDesign 的
  [`kit_abort()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_abort.md)、[`kit_is_user_error()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_is_user_error.md)）。
- 不要默默修正資料。要修的話，回傳的結果裡記下改了什麼。

### 4. 驗證算得對

- **對照另一個實作**：同一份資料用別的套件算（kits 有 kitsPreview，用
  dexter 與 cNORM 算同樣的結果），差異在容許範圍內。
- **模擬還原**：從已知參數模擬資料，估計值要回得到原參數（偏誤、RMSE
  在預期範圍）。
- **邊界情況**：全對、全錯、只有一題、只有一人、某一類沒有人、全部遺漏。要嘛算出合理的結果，要嘛停下來說為什麼。
- **數值容許度**：比較浮點數用容許度（例如 `1e-12`），並寫在測試裡。
- **可重現**：有隨機的地方用
  [`set.seed()`](https://rdrr.io/r/base/Random.html)，同樣的輸入每次得到同樣的結果。

### 5. 檔案格式

- 存起來給之後用的檔案（例如 kitsUI 的固定檔）要有**格式版本**與檢查碼。
- 新版要讀得了舊版的檔案；讀不了時說出是哪一版、要怎麼重做。測試裡放一份舊版的檔案。
- 改格式是 major（或在 0.x 時是 minor，NEWS 寫清楚）。

### 6. 結果變了要說出來

- 同一份資料算出不同的數字時，NEWS 的「Changes you can
  see」寫出：哪個結果、為什麼、差多少。
- 改估計方法或預設值是 major。
- 圖上的字照計算套件的英文；資料裡的名字（題號、世代）照資料的寫法。

------------------------------------------------------------------------

## 參考

- [版本與發布](https://jiewentsai.github.io/kitDesign/zh/articles/release.md)、[KIT
  設計語言](https://jiewentsai.github.io/kitDesign/zh/articles/design-language.md)、[遷移對照](https://github.com/jiewenTsai/kitDesign/blob/main/brand/%E9%81%B7%E7%A7%BB%E5%B0%8D%E7%85%A7.md)
- Hadley Wickham、Jennifer Bryan：[R Packages（第 2
  版）](https://r-pkgs.org)
- [rOpenSci 統計軟體同儕審查標準](https://stats-devguide.ropensci.org/)
- [Semantic Versioning](https://semver.org/lang/zh-TW/)
- [tidyverse 風格指南](https://style.tidyverse.org)
