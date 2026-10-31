# When the primary button cannot be pressed yet: disable it and show what is still needed above it

Put `shiny::uiOutput(ns("ready"))` on the page, directly followed by
`kit_button(ns("run"), ..., "primary", disabled = TRUE)` (disabled at
first; enabled once the server has checked). The primary button is shown
from the start, so people know what they will press at the end of this
page.

## Usage

``` r
kit_run_gate(
  session,
  output,
  missing,
  link = function() NULL,
  button_id = "run",
  output_id = "ready"
)
```

## Arguments

- session:

  The module's session.

- output:

  The module's output.

- missing:

  A reactive: what is still needed (character; length 0 = ready to run).

- link:

  function(): the link after "還差" ("Still needed") (a tag or `NULL`).

- button_id:

  The primary button's id (the id inside the module, without `ns()`).

- output_id:

  The [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) id
  for the "還差" line (the id inside the module).

## Value

`NULL`, invisibly; call it inside the server.

## Details

Still check again inside the button's
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html):
disabling is only on screen and must not be the only safeguard.

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    kit_run_gate(session, output, shiny::reactive(kit_need_files(1L, need = 2L)))
  }
}
```
