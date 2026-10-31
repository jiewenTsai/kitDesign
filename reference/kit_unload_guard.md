# Reminder before leaving the page

When there are results from this session (for example, after
calibration), the browser asks once before the tab is closed or
reloaded. Turn it on and off in the server based on the result:
`shiny::observe(kit_unload_guard(!is.null(result())))`.

## Usage

``` r
kit_unload_guard(on = TRUE, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- on:

  `TRUE` turns it on, `FALSE` turns it off.

- session:

  Defaults to the current session.

## Value

`on`, invisibly.

## Examples

``` r
if (interactive()) kit_unload_guard(TRUE)
```
