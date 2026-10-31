# 步驟分頁模組（NavTabs）

兩種樣子，同一套狀態（做完 ✓、還不能做灰色＋原因、要重新執行 ✓ 拿掉）：

## Usage

``` r
kit_step_tabs_ui(id, ..., groups = NULL, selected = NULL, aside = NULL)

kit_step_tabs_server(id, states = NULL, tips = NULL)
```

## Arguments

- id:

  模組的 id。

- ...:

  [`shiny::tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html)（`value`
  要寫）。

- groups:

  分組（[`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroup.md)
  的 list）；`NULL` 是有順序的流程。

- selected:

  一開始的分頁（value）。

- aside:

  流程分頁裡不是流程一步的分頁（value）。

- states:

  reactive（或函式）：每個分頁的狀態，具名字串向量或 list。值是
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)
  的狀態（`"success"`、`"warning"` 打 ✓；`"stale"` 拿掉 ✓）， 或直接寫
  `"done"`、`"locked"`、`"ready"`。沒有列出的分頁不改。`NULL`
  時不送狀態。

- tips:

  還不能做時滑過的說明：具名字串向量（或傳回它的
  reactive），或一句話給全部。

## Value

`kit_step_tabs_ui()`：分頁列與分頁。

`kit_step_tabs_server()`：list，

- `selected`：reactive，現在的分頁（value）；

- `select(value)`：換到某個分頁；

- `states`：reactive，送到瀏覽器的狀態（[`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_states.md)
  的結果）。

## Details

- 有順序的流程（kitsUI）：不給 `groups`，`...` 的
  [`tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html)
  名稱用圈數字； `aside` 的分頁（例如「使用手冊」）虛線、放最右邊。

- 分組、不編號（kitJoin）：給
  `groups`（[`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroup.md)
  的 list）；分頁列是
  [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroups.md)，真的分頁是藏起來的
  [`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html)。

分頁的 input 是 `input[["<id>-tabs"]]`；server 回傳的 `selected()`
是同一個值。

## See also

[`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_flow_tabs.md)、[`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroups.md)、[`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_states.md)（低階）

## Examples

``` r
if (interactive()) {
  ui <- kit_page("KIT 示範", NULL,
    kit_step_tabs_ui("nav",
      shiny::tabPanel("① 資料", value = "data", "…"),
      shiny::tabPanel("② 題目校準", value = "items", "…")
    )
  )
  server <- function(input, output, session) {
    kit_step_tabs_server("nav",
      states = shiny::reactive(c(data = "success", items = "locked")),
      tips = c(items = "先在「① 資料」選好資料")
    )
  }
  shiny::shinyApp(ui, server)
}
```
