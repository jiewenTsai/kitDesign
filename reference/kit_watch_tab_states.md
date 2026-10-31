# Send tab states to the browser whenever they change

`kit_watch_tab_states(session, shiny::reactive(kit_tab_states(...)))`.

## Usage

``` r
kit_watch_tab_states(session, states)
```

## Arguments

- session:

  The Shiny session.

- states:

  A reactive: the result of
  [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md).

## Value

The [`shiny::observe()`](https://rdrr.io/pkg/shiny/man/observe.html)
observer (invisibly).

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    kit_watch_tab_states(session, shiny::reactive(kit_tab_states(list(upload = "success"))))
  }
}
```
