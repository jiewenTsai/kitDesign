# 下載按鈕（DownloadButton）

外觀和
[`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html)
一樣，但中文檔名在每個瀏覽器都存得對：網址最後一段、
`Content-Disposition` 標頭（`filename` 與 `filename*`）、`<a download>`
都是同一個檔名。 放在
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)
裡：重畫時重新註冊，網址跟著換，不會拿到舊檔。

## Usage

``` r
kit_download_button(
  session,
  id,
  label,
  filename,
  content,
  class = NULL,
  app = getOption("kitDesign.app", "kit")
)
```

## Arguments

- session:

  模組的 session（id 會自動加上 namespace）。

- id:

  按鈕 id（不含 namespace）。

- label:

  按鈕的字，例如「下載 CSV」。

- filename:

  下載檔名（字串；可以有中文與空白）。

- content:

  `function(file)`：把檔案寫到 `file`。

- class:

  另外加的 class，例如 `kit_btn_class("secondary")`、`"btn-primary"`。

- app:

  app 的名稱：log 訊息用它；檔名全是中文時，舊瀏覽器用的 ASCII
  備用名是它的小寫 （「第一波.csv」→「kitjoin.csv」）。預設是
  `getOption("kitDesign.app", "kit")`： app 在 `.onLoad()` 設定一次。

## Value

`<a class="btn btn-default kit-download" download="檔名">`。

## Details

檔案在按下載時才寫（`content(file)`，可以讀
reactive）。寫檔出錯時：錯誤寫進 log （「 下載失敗（檔名）：…」）、這個
session 跳出紅色通知（不會自己消失）、 回應 500
與同一句話。[`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
的訊息照原文給使用者看，其他錯誤不給內部訊息。

`Content-Type` 照副檔名：`.csv`、`.zip`、`.html` 用各自的
MIME；其他（`.sav`、`.csv.gz`） 都是 `application/octet-stream`，照 MIME
補副檔名的瀏覽器才不會多加一個副檔名。

## See also

[`kit_test_download()`](https://jiewentsai.github.io/kitDesign/reference/kit_test_download.md)（測試用）

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    output$dl_ui <- shiny::renderUI(kit_download_button(
      session, "dl", "下載 CSV", "第一波 資料.csv",
      function(file) utils::write.csv(mtcars, file)
    ))
  }
}
```
