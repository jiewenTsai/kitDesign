# 步驟卡模組（StepCard）

一頁裡有好幾步、而且有先後時用：一次只打開一步，做完的收成一行（✓、摘要、「改」），
還不能做的是灰的。每一步最下面是「對，下一步」（一般按鈕）；按了以後這一步做完、
打開下一個還沒做完的步驟。做完的按「改」回去。

## Usage

``` r
kit_stepcards_ui(id, ..., next_label = "對，下一步")

kit_stepcards_server(
  id,
  titles,
  summaries = list(),
  checks = list(),
  start = 1L
)
```

## Arguments

- id:

  模組的 id。

- ...:

  每一步的內容（一步一個 tag 或
  [`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)，依順序）。

- next_label:

  每一步最下面的按鈕字。

- titles:

  每一步的標題（字串向量，長度＝步數）。

- summaries:

  每一步做完時的摘要：list，一步一個（字串、函式或 reactive；`NULL`
  不顯示）。

- checks:

  按「對，下一步」前的檢查：list，一步一個函式，傳回還差的事（字串向量；
  長度 0 =
  可以往下）。還差時這一步不算做完，按鈕上面列出「還差：…」（[`kit_problems()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_problems.md)）。

- start:

  一開始打開第幾步。

## Value

`kit_stepcards_ui()`：[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)，裡面是一張張
[`kit_step_card()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_card.md)。

`kit_stepcards_server()`：list，

- `current`：reactive，現在打開第幾步（都做完時是 0）；

- `done`：reactive，每一步做完了沒有（logical 向量）；

- `open(k)`：打開第 k 步（例如資料改了，要回第 1 步）；

- `reset()`：全部回到還沒做，打開第 1 步。

## Details

`kit_stepcards_ui()` 放每一步的內容（依順序）；`kit_stepcards_server()`
給每一步的標題、 做完時的摘要、按「對，下一步」前的檢查。

## See also

[`kit_step_card()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_card.md)、[`kit_step_head()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_step_head.md)（低階）

## Examples

``` r
if (interactive()) {
  ui <- kit_page("KIT 示範", NULL,
    kit_stepcards_ui("steps",
      shiny::p("每個檔案是哪個世代、哪個波次。"),
      shiny::p("哪些欄是題目。"),
      shiny::p("計分檢查。")
    )
  )
  server <- function(input, output, session) {
    steps <- kit_stepcards_server("steps",
      titles = c("每個檔案是哪個世代、哪個波次", "哪些欄是題目", "計分檢查"),
      summaries = list("5 個檔案", function() "45 題", "沒有要決定的事")
    )
  }
  shiny::shinyApp(ui, server)
}
```
