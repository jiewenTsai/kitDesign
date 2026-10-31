# 主要按鈕＋「還差：…」模組（ReadyLine）

主要按鈕一開始就顯示（停用）；還差的事（[`missing()`](https://rdrr.io/r/base/missing.html)）是空的時才能按，
上面一行粗體「還差：…」，後面接一個去處理的連結。 server 回傳的 reactive
只有在**沒有還差的事時**按下去才會變（伺服器端也擋，
不只靠按鈕停用），所以直接 `observeEvent(run(), …)` 就好。

## Usage

``` r
kit_run_gate_ui(id, label, ...)

kit_run_gate_server(id, missing, link = function() NULL)
```

## Arguments

- id:

  模組的 id。

- label:

  主要按鈕的字（動詞開頭，例如「執行串接」）。

- ...:

  其他傳給
  [`kit_button()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_button.md)
  的參數。

- missing:

  reactive：還差的事（字串向量；長度 0 = 可以執行）。

- link:

  函式：跟在「還差」後面的連結（tag 或 `NULL`）。

## Value

`kit_run_gate_ui()`：「還差」的位置與主要按鈕。

`kit_run_gate_server()`：reactive，可以執行時按了幾次（一開始是 0）。

## See also

[`kit_ready_line()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_ready_line.md)、[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_run_gate.md)（低階）

## Examples

``` r
if (interactive()) {
  ui <- kit_page("KIT 示範", NULL,
    shiny::selectInput("id_col", "ID 欄", c("", "subj_id")),
    kit_run_gate_ui("run", "執行串接")
  )
  server <- function(input, output, session) {
    run <- kit_run_gate_server("run", shiny::reactive(if (input$id_col == "") "選 ID 欄"))
    shiny::observeEvent(run(), message("執行"), ignoreInit = TRUE)
  }
  shiny::shinyApp(ui, server)
}
```
