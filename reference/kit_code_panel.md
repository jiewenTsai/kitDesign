# Placeholder for "How to do it in R" (code panel)

A
[`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md)
inside the details row
([`kit_details_row()`](https://jiewentsai.github.io/kitDesign/reference/kit_details_row.md)),
collapsed by default; the server fills `output_id` with
[`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md).
With modules, use
[`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md).

## Usage

``` r
kit_code_panel(output_id, title = "用 R 怎麼做", open = FALSE)
```

## Arguments

- output_id:

  The [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) id
  that holds the content (wrap in `ns()` inside a module).

- title:

  The collapsible title.

- open:

  Whether it starts open (collapsed by default).

## Value

`<details class="kit-detail">`.

## Examples

``` r
kit_details_row(kit_detail("預覽", "…"), kit_code_panel("code"))  # "Preview"
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
