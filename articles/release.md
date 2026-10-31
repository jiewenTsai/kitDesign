# 版本與發布

> 這一頁就是 kitDesign 裡的
> `brand/版本與發布.md`。每一版改了什麼見[更新紀錄](https://jiewentsai.github.io/kitDesign/news/index.md)。

kitDesign 是 kitJoin、kitsUI 與之後的 KIT app
共用的介面。三個套件的版本各自走， 靠「app 指定它用哪一版
kitDesign」協調。

## 版本號：語意化版本（X.Y.Z）

| 改了什麼 | 加哪一位 | 例子 |
|----|----|----|
| 修正，畫面和函式都沒有變 | **patch**（0.1.0 → 0.1.1） | 修 JavaScript 的錯、修文件、修測試 |
| 新的元件或選項，舊的 app 不用改 | **minor**（0.1.1 → 0.2.0） | 新增 `kit_xxx()`；既有函式多一個有預設值的參數 |
| 函式改名或拿掉、參數意思變了、**看得到的設計改變** | **major**（0.2.0 → 1.0.0） | 改狀態框的顏色、改按鈕的大小、拿掉 [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md) |

- 1.0.0 以前（0.x）也照這個規則；第一個兩個 app 都改用 kitDesign
  的版本建議發 1.0.0。
- 看得到的改變一律算
  major：使用者看到的畫面是「設計語言」的一部分，改了要通知兩個 app。
- `KIT設計語言.md` 的版本和 kitDesign 分開；設計語言改版時，在 NEWS.md
  寫出對應的 kitDesign 版本。

## 每次發布

1.  改 `DESCRIPTION` 的 `Version` 與 `Date`。

2.  `NEWS.md`
    最上面加一段：`# kitDesign X.Y.Z (YYYY-MM-DD)`，分「元件」「修正」「看得到的改變」。

3.  檢查（都要過）：

    ``` sh
    LC_ALL=en_US.UTF-8 Rscript tools/escape_non_ascii.R
    LC_ALL=en_US.UTF-8 Rscript -e 'roxygen2::roxygenise()'
    LC_ALL=en_US.UTF-8 R CMD build .
    LC_ALL=en_US.UTF-8 R CMD check --no-manual kitDesign_X.Y.Z.tar.gz   # 0 errors、0 warnings
    LC_ALL=en_US.UTF-8 Rscript tools/check_gallery.R                     # 截圖、不能左右捲
    ```

4.  看 `tools/check_gallery.R` 的截圖（1280 與 390 寬），和上一版比。

5.  commit，打 tag：`git tag vX.Y.Z`，推上
    GitHub（`git push origin main --tags`）。

## app 升級 kitDesign

1.  app 的 `DESCRIPTION`：
    - `Imports: kitDesign (>= X.Y.Z)`
    - `Remotes: jiewenTsai/kitDesign@vX.Y.Z`（固定在 tag，不跟著 main
      跑）
2.  安裝那一版：`remotes::install_github("jiewenTsai/kitDesign@vX.Y.Z")`。
3.  跑 app 的測試；major 升級時照 NEWS.md 的「看得到的改變」與
    `遷移對照.md` 改程式，截圖對照。
4.  重新產生 `manifest.json`（`rsconnect::writeManifest()`），部署。
5.  app 自己也加版本（通常是 patch；畫面變了就是 minor），NEWS.md
    寫「改用 kitDesign X.Y.Z」。

## 回報問題時

頁首的版本行寫出兩個版本（`kit_page(..., show_kitdesign = TRUE)`）：
「v0.5.0 · 2026-10-31 · kitDesign 0.1.0」。在 R 裡用
`kit_versions("kitJoin")`。

## 發布前的檢查清單

`DESCRIPTION` 的 Version、Date 改了

`NEWS.md` 有這一版

R 程式碼只有 ASCII（`tools/escape_non_ascii.R`）

`R CMD check`：0 errors、0 warnings

`tools/check_gallery.R`：1280 與 390 寬都沒有左右捲；截圖看過

看得到的改變：版本是 major，`遷移對照.md` 或 NEWS.md 寫了怎麼改

tag `vX.Y.Z`

通知 kitJoin、kitsUI：要不要升級、要改什麼
