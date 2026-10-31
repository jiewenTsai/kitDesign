# Primary button + "Still needed: …" module (ready line)

The primary button is shown (disabled) from the start; it can be pressed
only when nothing is still needed
([`missing()`](https://rdrr.io/r/base/missing.html) is empty). Above it,
a bold line says "還差：…" ("Still needed: …"), followed by a link to
where to fix it. The reactive returned by the server changes only when
the button is pressed **while nothing is still needed** (the server also
blocks it, not just the disabled button), so a plain
`observeEvent(run(), …)` is enough.

## Usage

``` r
kit_run_gate_ui(id, label, ...)

kit_run_gate_server(id, missing, link = function() NULL)
```

## Arguments

- id:

  The module id.

- label:

  The primary button's text (start with a verb, for example "執行串接",
  "Run join").

- ...:

  Other arguments passed to
  [`kit_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_button.md).

- missing:

  A reactive: what is still needed (character vector; length 0 = ready
  to run).

- link:

  A function: the link after "還差" ("Still needed") (a tag or `NULL`).

## Value

`kit_run_gate_ui()`: the slot for the "還差" line and the primary
button.

`kit_run_gate_server()`: a reactive counting presses made while ready to
run (0 at first).

## See also

[`kit_ready_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_ready_line.md),
[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md)
(low-level)

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
