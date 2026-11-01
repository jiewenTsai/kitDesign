# 有順序的流程分頁（kitsUI 的樣子）

一般的
[`shiny::tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html)，分頁名稱用圈數字（①
資料、② 題目校準…）。 不是流程一步的分頁（例如「使用手冊」）寫在
`aside`：虛線框、沒有陰影、推到最右邊。 做完打 ✓（分頁裡多一個
`.kit-tab-mark`）、還不能做灰色（[`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_send_tab_states.md)）。

## Usage

``` r
kit_flow_tabs(..., id = "tabs", selected = NULL, aside = NULL)
```

## Arguments

- ...:

  [`shiny::tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html)。

- id:

  tabsetPanel 的 id（`input[[id]]` 是目前的分頁）。

- selected:

  一開始的分頁（value）。

- aside:

  不是流程一步的分頁的 value（字串向量）。

## Value

`<div class="kit-flow-tabs">`，裡面是
[`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html)。

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
#>     <ul class="nav nav-tabs shiny-tab-input" id="flow" data-tabsetid="7491">
#>       <li class="active">
#>         <a href="#tab-7491-1" data-toggle="tab" data-bs-toggle="tab" data-value="data">① 資料</a>
#>       </li>
#>       <li>
#>         <a href="#tab-7491-2" data-toggle="tab" data-bs-toggle="tab" data-value="items">② 題目校準</a>
#>       </li>
#>       <li>
#>         <a href="#tab-7491-3" data-toggle="tab" data-bs-toggle="tab" data-value="manual">使用手冊</a>
#>       </li>
#>     </ul>
#>     <div class="tab-content" data-tabsetid="7491">
#>       <div class="tab-pane active" data-value="data" id="tab-7491-1"></div>
#>       <div class="tab-pane" data-value="items" id="tab-7491-2"></div>
#>       <div class="tab-pane" data-value="manual" id="tab-7491-3"></div>
#>     </div>
#>   </div>
#> </div>
```
