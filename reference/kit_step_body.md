# 步驟卡的內容

卡片裡的表不加外框、淡表頭（CSS 會處理）；手機上不縮排。

## Usage

``` r
kit_step_body(...)
```

## Arguments

- ...:

  這一步的內容；最後通常是「對，下一步」（[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)，一般按鈕）。

## Value

`<div class="kit-stepbody">`。

## Examples

``` r
kit_step_body(shiny::p("說明"), shiny::actionButton("ok1", "對，下一步"))
#> <div class="kit-stepbody">
#>   <p>說明</p>
#>   <button id="ok1" type="button" class="btn btn-default action-button"><span class="action-label">對，下一步</span></button>
#> </div>
```
