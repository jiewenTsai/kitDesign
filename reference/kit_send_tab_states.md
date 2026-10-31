# Send tab states to the browser

Works with both kinds of tab bar: grouped tab bars
([`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md),
`data-tabset` is `tabset`) and flow tabs
([`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/reference/kit_flow_tabs.md),
`id` is `tabset`).

## Usage

``` r
kit_send_tab_states(states, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- states:

  The result of
  [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md).

- session:

  Defaults to the current session.

## Value

`states`, invisibly.

## Examples

``` r
if (interactive()) kit_send_tab_states(kit_tab_states(list(upload = "success")))
```
