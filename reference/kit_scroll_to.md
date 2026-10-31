# After running, scroll the status box to the top of the screen

"Results first, details after": call `kit_scroll_to("status")` at the
end of the primary button's
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html). It
scrolls only after this round's outputs have all reached the browser
(`session$onFlushed()`), so the status box is already rendered. When the
user has set "reduce motion", it jumps there without smooth scrolling.

## Usage

``` r
kit_scroll_to(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  The output id inside the module (the module's namespace is added
  automatically), for example `"status"`.

- session:

  Defaults to the current session (called inside a module, that is the
  module's session).

## Value

The full id, invisibly; `NULL` when there is no session.

## Examples

``` r
if (interactive()) {
  shiny::observeEvent(input$run, {
    # …run…
    kit_scroll_to("status")
  })
}
```
