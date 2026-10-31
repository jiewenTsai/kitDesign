# Ordered workflow tabs (the kitsUI style)

A regular
[`shiny::tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html)
with circled numbers in the tab names (① 資料, ② 題目校準…; "Data",
"Item calibration"). Tabs that are not a workflow step (e.g. "使用手冊",
"User manual") go in `aside`: dashed border, no shadow, pushed to the
far right. Done tabs get a ✓ (an extra `.kit-tab-mark` in the tab); tabs
that can't be used yet are gray
([`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_send_tab_states.md)).

## Usage

``` r
kit_flow_tabs(..., id = "tabs", selected = NULL, aside = NULL)
```

## Arguments

- ...:

  [`shiny::tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html).

- id:

  The tabsetPanel id (`input[[id]]` is the current tab).

- selected:

  The tab to start on (value).

- aside:

  Values of tabs that are not a workflow step (a character vector).

## Value

`<div class="kit-flow-tabs">` containing a
[`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html).

## Examples

``` r
kit_flow_tabs(
  shiny::tabPanel("① 資料", value = "data"),
  shiny::tabPanel("② 題目校準", value = "items"),
  shiny::tabPanel("使用手冊", value = "manual"),
  id = "flow", aside = "manual"
)
#> <div class="kit-flow-tabs" data-kit-aside="manual">
#>   <div class="tabbable">
#>     <ul class="nav nav-tabs shiny-tab-input" id="flow" data-tabsetid="3420">
#>       <li class="active">
#>         <a href="#tab-3420-1" data-toggle="tab" data-bs-toggle="tab" data-value="data">① 資料</a>
#>       </li>
#>       <li>
#>         <a href="#tab-3420-2" data-toggle="tab" data-bs-toggle="tab" data-value="items">② 題目校準</a>
#>       </li>
#>       <li>
#>         <a href="#tab-3420-3" data-toggle="tab" data-bs-toggle="tab" data-value="manual">使用手冊</a>
#>       </li>
#>     </ul>
#>     <div class="tab-content" data-tabsetid="3420">
#>       <div class="tab-pane active" data-value="data" id="tab-3420-1"></div>
#>       <div class="tab-pane" data-value="items" id="tab-3420-2"></div>
#>       <div class="tab-pane" data-value="manual" id="tab-3420-3"></div>
#>     </div>
#>   </div>
#> </div>
```
