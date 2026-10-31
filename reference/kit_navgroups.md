# Grouped tab bar (unnumbered; the kitJoin style)

Tabs are split into groups, each with a line of small gray text above
it. On click, `kit.js` switches the hidden
`tabsetPanel(id = tabset, type = "hidden")`; after a switch (including
[`updateTabsetPanel()`](https://rdrr.io/pkg/shiny/man/updateTabsetPanel.html))
it marks the current tab as active. The ✓ for done tabs and the gray for
tabs not yet usable are also applied to these links
([`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_send_tab_states.md)).
At ≤ 768px the bar becomes one row that scrolls sideways.

## Usage

``` r
kit_navgroups(groups, tabset = "tabs", selected = NULL)
```

## Arguments

- groups:

  A list of
  [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroup.md).

- tabset:

  The id of the matching
  [`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html).

- selected:

  The tab to start on (value); defaults to the first.

## Value

`<nav class="kit-navgroups">`.

## Examples

``` r
groups <- list(
  kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理")),
  kit_navgroup("做出資料（選一個）", c(join = "橫向資料串接", stack = "直向波次疊加")),
  kit_navgroup("其他工具", c(convert = "檔案格式轉換"), tools = TRUE)
)
# Groups: "Prepare" (File upload, Missing values), "Make the data (pick one)"
# (Wide join, Long stack of waves), "Other tools" (File format conversion)
kit_navgroups(groups, "tabs")
#> <nav class="kit-navgroups" data-tabset="tabs" aria-label="分頁">
#>   <div class="kit-navgroup">
#>     <div class="kit-navgroup-label">準備</div>
#>     <ul class="nav nav-tabs">
#>       <li class="nav-item">
#>         <a class="nav-link active" href="#" data-kit-tab="upload" aria-current="page">檔案上傳</a>
#>       </li>
#>       <li class="nav-item">
#>         <a class="nav-link" href="#" data-kit-tab="missing">遺漏值處理</a>
#>       </li>
#>     </ul>
#>   </div>
#>   <div class="kit-navgroup">
#>     <div class="kit-navgroup-label">做出資料（選一個）</div>
#>     <ul class="nav nav-tabs">
#>       <li class="nav-item">
#>         <a class="nav-link" href="#" data-kit-tab="join">橫向資料串接</a>
#>       </li>
#>       <li class="nav-item">
#>         <a class="nav-link" href="#" data-kit-tab="stack">直向波次疊加</a>
#>       </li>
#>     </ul>
#>   </div>
#>   <div class="kit-navgroup tools">
#>     <div class="kit-navgroup-label">其他工具</div>
#>     <ul class="nav nav-tabs">
#>       <li class="nav-item">
#>         <a class="nav-link" href="#" data-kit-tab="convert">檔案格式轉換</a>
#>       </li>
#>     </ul>
#>   </div>
#> </nav>
# Then on the page:
# shiny::tabsetPanel(id = "tabs", type = "hidden",
#   shiny::tabPanel("檔案上傳", value = "upload", ...), ...)
```
