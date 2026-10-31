# server 端：把程式碼畫進 [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel.md)

`output[["code"]] <- kit_render_code_panel(function() code_text())`。
收起來時不算（Shiny 不畫看不見的 output；打開「用 R
怎麼做」時才算）。[`code()`](https://rstudio.github.io/htmltools/reference/builder.html)
停下來
（[`req()`](https://rdrr.io/pkg/shiny/man/req.html)）、出錯或是空的時，只有一行
`empty`。

## Usage

``` r
kit_render_code_panel(
  code,
  note = KIT_CODE_NOTE,
  width = KIT_CODE_WIDTH,
  empty = KIT_CODE_EMPTY
)
```

## Arguments

- code:

  傳回程式碼的函式或
  reactive：[`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_blocks.md)
  的 `snips`。

- note, width:

  見
  [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_blocks.md)。

- empty:

  還沒有程式碼時的一行字。

## Value

[`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)。

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    output$code <- kit_render_code_panel(function() "x <- 1")
  }
}
```
