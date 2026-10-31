# 「用 R 怎麼做」的位置（CodePanel）

細節列（[`kit_details_row()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_details_row.md)）裡的一個
[`kit_detail()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_detail.md)，預設收起；內容由
server 用
[`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_render_code_panel.md)
填進 `output_id`。用模組時是
[`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel_ui.md)。

## Usage

``` r
kit_code_panel(output_id, title = "用 R 怎麼做", open = FALSE)
```

## Arguments

- output_id:

  放內容的 [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)
  id（模組裡要加 `ns()`）。

- title:

  收合標題。

- open:

  一開始要不要打開（預設收起）。

## Value

`<details class="kit-detail">`。

## Examples

``` r
kit_details_row(kit_detail("預覽", "…"), kit_code_panel("code"))
#> <div class="kit-details">
#>   <details class="kit-detail">
#>     <summary>預覽</summary>
#>     <div class="kit-detail-body">…</div>
#>   </details>
#>   <details class="kit-detail">
#>     <summary>用 R 怎麼做</summary>
#>     <div class="kit-detail-body">
#>       <div id="code" class="shiny-html-output"></div>
#>     </div>
#>   </details>
#> </div>
```
