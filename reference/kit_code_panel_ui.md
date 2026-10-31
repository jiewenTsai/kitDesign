# "How to do it in R" module (code panel)

A collapsible block in the details row; the code is computed only when
it is opened (Shiny does not render outputs inside a collapsed block),
and rendered as one or more
[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
(at most 70 columns per line, with "Copy").

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

  The module id.

- title:

  The collapsible title.

- open:

  Whether it starts open.

- code:

  A function or reactive returning the code: a string, a
  [`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md),
  or a named list of them (see `snips` in
  [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md)).

- note, width, empty:

  See
  [`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md).

## Value

`kit_code_panel_ui()`: `<details class="kit-detail">`, placed last in
[`kit_details_row()`](https://jiewentsai.github.io/kitDesign/reference/kit_details_row.md).

`kit_code_panel_server()`: a reactive with the current code (a list of
[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md);
`NULL` when there is none yet).

## See also

[`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md),
[`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md)
(low level)

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
