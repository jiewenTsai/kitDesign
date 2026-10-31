# Server side: render code into [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)

`output[["code"]] <- kit_render_code_panel(function() code_text())`.
Nothing is computed while the panel is collapsed (Shiny does not render
hidden outputs; it computes only when "用 R 怎麼做" ("How to do it in
R") is opened). When
[`code()`](https://rstudio.github.io/htmltools/reference/builder.html)
stops ([`req()`](https://rdrr.io/pkg/shiny/man/req.html)), fails, or is
empty, only the `empty` line is shown.

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

  A function or reactive that returns the code: the `snips` of
  [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md).

- note, width:

  See
  [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md).

- empty:

  The one line shown while there is no code yet.

## Value

[`shiny::renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html).

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    output$code <- kit_render_code_panel(function() "x <- 1")
  }
}
```
