# 表格或清單裡的問題（深橘紅的字）

步驟卡裡「還差：…」或「這幾欄有問題」這類單一問題的清單。

## Usage

``` r
kit_problems(..., head = NULL, bullets = TRUE)
```

## Arguments

- ...:

  每個問題一個字串（或 tag）。

- head:

  前面的粗體字，例如「還差：」；`NULL` 不顯示。

- bullets:

  `TRUE`（預設）每個問題一個項目符號；`FALSE` 一行一個、不加符號
  （例如每一行已經是完整的句子，或前面自己有編號）。

## Value

`<div class="kit-problems">`；沒有問題時是 `NULL`。

## Examples

``` r
kit_problems("第 2 列沒有選世代", "第 4 列的波次不是數字", head = "還差：")
#> <div class="kit-problems">
#>   <strong>還差：</strong>
#>   <ul>
#>     <li>第 2 列沒有選世代</li>
#>     <li>第 4 列的波次不是數字</li>
#>   </ul>
#> </div>
kit_problems("bsrs1：w1d5_1 和 w2d5_1 的分數範圍不同", bullets = FALSE)
#> <div class="kit-problems">
#>   <div>bsrs1：w1d5_1 和 w2d5_1 的分數範圍不同</div>
#> </div>
```
