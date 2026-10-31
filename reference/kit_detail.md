# One detail: collapsed by default, a one-line small-print title

Outputs inside a collapsed detail are computed only when it is opened:
`kit.js` tells Shiny to check again when it opens.

## Usage

``` r
kit_detail(title, ..., open = FALSE)
```

## Arguments

- title:

  The title (a noun: "題目參數" ("Item parameters"), "這一回合的紀錄"
  ("Log for this round")).

- ...:

  The content.

- open:

  Whether it starts open.

## Value

`<details class="kit-detail">`.

## Examples

``` r
kit_detail("預覽", shiny::tags$p("前 10 列"))  # "Preview", "First 10 rows"
#> <details class="kit-detail">
#>   <summary>預覽</summary>
#>   <div class="kit-detail-body">
#>     <p>前 10 列</p>
#>   </div>
#> </details>
```
