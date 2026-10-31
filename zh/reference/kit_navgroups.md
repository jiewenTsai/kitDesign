# 分組的分頁列（不編號；kitJoin 的樣子）

分頁分成幾組，每組上面一行灰色小字。按下去時由 `kit.js` 切換藏起來的
`tabsetPanel(id = tabset, type = "hidden")`；切換以後（包括
[`updateTabsetPanel()`](https://rdrr.io/pkg/shiny/man/updateTabsetPanel.html)）
再把目前的分頁標成 active。做完打 ✓、還不能用變灰也加在這些連結上
（[`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_send_tab_states.md)）。≤
768px 時一排左右滑。

## Usage

``` r
kit_navgroups(groups, tabset = "tabs", selected = NULL)
```

## Arguments

- groups:

  [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroup.md)
  的 list。

- tabset:

  對應的
  [`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html) 的
  id。

- selected:

  一開始的分頁（value）；預設是第一個。

## Value

`<nav class="kit-navgroups">`。

## Examples

``` r
groups <- list(
  kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理")),
  kit_navgroup("做出資料（選一個）", c(join = "橫向資料串接", stack = "直向波次疊加")),
  kit_navgroup("其他工具", c(convert = "檔案格式轉換"), tools = TRUE)
)
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
# 頁面上接著放：
# shiny::tabsetPanel(id = "tabs", type = "hidden",
#   shiny::tabPanel("檔案上傳", value = "upload", ...), ...)
```
