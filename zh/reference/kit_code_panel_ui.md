# 「用 R 怎麼做」模組（CodePanel）

細節列裡的一個收合區塊；打開時才算程式碼（收起來時 Shiny 不畫裡面的
output）， 畫成一個或幾個
[`kit_code()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code.md)（每行最多
70 欄、附「複製」）。

## Usage

``` r
kit_code_panel_ui(id, title = "用 R 怎麼做", open = FALSE)

kit_code_panel_server(
  id,
  code,
  note = KIT_CODE_NOTE,
  width = KIT_CODE_WIDTH,
  empty = KIT_CODE_EMPTY
)
```

## Arguments

- id:

  模組的 id。

- title:

  收合標題。

- open:

  一開始要不要打開。

- code:

  傳回程式碼的函式或
  reactive：一個字串、[`kit_code()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code.md)，或它們的具名
  list （見
  [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_blocks.md)
  的 `snips`）。

- note, width, empty:

  見
  [`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_render_code_panel.md)。

## Value

`kit_code_panel_ui()`：`<details class="kit-detail">`，放在
[`kit_details_row()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_details_row.md)
的最後。

`kit_code_panel_server()`：reactive，現在的程式碼（[`kit_code()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code.md)
的 list；還沒有時是 `NULL`）。

## See also

[`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel.md)、[`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_render_code_panel.md)（低階）

## Examples

``` r
if (interactive()) {
  ui <- kit_page("KIT 示範", NULL, kit_details_row(kit_code_panel_ui("code")))
  server <- function(input, output, session) {
    kit_code_panel_server("code", function() list(tidy = "x <- 1", base = "x <- 1"))
  }
  shiny::shinyApp(ui, server)
}
```
