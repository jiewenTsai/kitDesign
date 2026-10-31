# 一個細節：預設收起，標題一行小字

收起來的 output 要打開才算出來：`kit.js` 會在打開時通知 Shiny 重新檢查。

## Usage

``` r
kit_detail(title, ..., open = FALSE)
```

## Arguments

- title:

  標題（名詞：「題目參數」「這一回合的紀錄」）。

- ...:

  內容。

- open:

  一開始要不要打開。

## Value

`<details class="kit-detail">`。

## Examples

``` r
kit_detail("預覽", shiny::tags$p("前 10 列"))
#> <details class="kit-detail">
#>   <summary>預覽</summary>
#>   <div class="kit-detail-body">
#>     <p>前 10 列</p>
#>   </div>
#> </details>
```
