# Step tabs module

Two looks, one set of states (done ✓; not yet available gray plus the
reason; run again removes the ✓):

## Usage

``` r
kit_step_tabs_ui(id, ..., groups = NULL, selected = NULL, aside = NULL)

kit_step_tabs_server(id, states = NULL, tips = NULL)
```

## Arguments

- id:

  The module id.

- ...:

  [`shiny::tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html)s
  (`value` is required).

- groups:

  Groups (a list of
  [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroup.md));
  `NULL` means an ordered flow.

- selected:

  The tab selected at the start (value).

- aside:

  Tabs in a flow that are not a step of the flow (value).

- states:

  A reactive (or function): the state of each tab, a named character
  vector or list. Values are
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  states (`"success"` and `"warning"` add a ✓; `"stale"` removes the ✓),
  or directly `"done"`, `"locked"`, `"ready"`. Tabs not listed are left
  unchanged. With `NULL`, no states are sent.

- tips:

  The hover text for tabs not yet available: a named character vector
  (or a reactive that returns one), or one sentence for all.

## Value

`kit_step_tabs_ui()`: the tab bar and the tabs.

`kit_step_tabs_server()`: a list,

- `selected`: a reactive, the current tab (value);

- `select(value)`: switches to a tab;

- `states`: a reactive, the states sent to the browser (the result of
  [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md)).

## Details

- Ordered flow (kitsUI): do not pass `groups`; the
  [`tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html) names in
  `...` use circled numbers; `aside` tabs (for example "使用手冊", "User
  manual") are dashed and placed at the far right.

- Grouped, unnumbered (kitJoin): pass `groups` (a list of
  [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroup.md));
  the tab bar is
  [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md),
  and the real tabs are a hidden
  [`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html).

The tabs' input is `input[["<id>-tabs"]]`; the `selected()` returned by
the server is the same value.

## See also

[`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/reference/kit_flow_tabs.md),
[`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md),
[`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md)
(low-level)

## Examples

``` r
if (interactive()) {
  ui <- kit_page("KIT 示範", NULL,
    kit_step_tabs_ui("nav",
      shiny::tabPanel("① 資料", value = "data", "…"),
      shiny::tabPanel("② 題目校準", value = "items", "…")
    )
  )
  server <- function(input, output, session) {
    kit_step_tabs_server("nav",
      states = shiny::reactive(c(data = "success", items = "locked")),
      tips = c(items = "先在「① 資料」選好資料")
    )
  }
  shiny::shinyApp(ui, server)
}
```
