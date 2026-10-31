# 圖的類別色（Chart）

色盲友善的
Okabe–Ito，世代、量尺、分數依序取色：藍、橘、綠、紫紅、天藍、朱紅； 超過
6 類從頭再取。參考線、帶子、沒有判斷的點用
[`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md)。

## Usage

``` r
kit_chart_colors(n = NULL)
```

## Arguments

- n:

  `NULL` 時回傳全部 6 個（具名）；給數字時依序取 `n` 個（不具名）。

## Value

顏色字串向量。

## Examples

``` r
kit_chart_colors()
#>       blue     orange      green     purple        sky vermillion 
#>  "#0072B2"  "#E69F00"  "#009E73"  "#CC79A7"  "#56B4E9"  "#D55E00" 
kit_chart_colors(3)
#> [1] "#0072B2" "#E69F00" "#009E73"
```
