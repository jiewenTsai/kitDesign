# 連續數值的色階（Chart）

極淡萊姆 → 淡萊姆（`bg-new`）→ KIT
綠（`nb-green`）：值越大越深。用在熱圖、色條
（例如作答設計圖的通過比例）。最小值不是白色，所以 0
和沒有資料的空格（白底）看得出來不同。[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
預設把熱圖換成這個色階。

## Usage

``` r
kit_chart_sequential(brand = kit_current_brand())
```

## Arguments

- brand:

  品牌（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)）；預設是
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)（沒有設定時是
  KIT）。

## Value

plotly 的
colorscale：`list(list(0, "#F3F7D3"), ..., list(1, "#006835"))`。

## Details

色階從品牌來（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)）：0
是 `accent_light` 再和白色混合的極淡色，0.2 是 `accent_light`，0.2 到 1
在 Lab 空間從 `accent_light` 內插到 `primary`。KIT 的品牌
就是上面的值。類別色（[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md)，Okabe–Ito）不跟著品牌換：它們是色盲友善的。

## See also

[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)、[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md)

## Examples

``` r
kit_chart_sequential()
#> [[1]]
#> [[1]][[1]]
#> [1] 0
#> 
#> [[1]][[2]]
#> [1] "#F3F7D3"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 0.2
#> 
#> [[2]][[2]]
#> [1] "#E8F0A0"
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [1] 0.4
#> 
#> [[3]][[2]]
#> [1] "#B3CC83"
#> 
#> 
#> [[4]]
#> [[4]][[1]]
#> [1] 0.6
#> 
#> [[4]][[2]]
#> [1] "#7FAA68"
#> 
#> 
#> [[5]]
#> [[5]][[1]]
#> [1] 0.8
#> 
#> [[5]][[2]]
#> [1] "#4B884D"
#> 
#> 
#> [[6]]
#> [[6]][[1]]
#> [1] 1
#> 
#> [[6]][[2]]
#> [1] "#006835"
#> 
#> 
kit_chart_sequential(kit_brand("Demo", colors = list(accent = "#9cc0ff", primary = "#1f4fa3")))
#> [[1]]
#> [[1]][[1]]
#> [1] 0
#> 
#> [[1]][[2]]
#> [1] "#EBF1FF"
#> 
#> 
#> [[2]]
#> [[2]][[1]]
#> [1] 0.2
#> 
#> [[2]][[2]]
#> [1] "#D4E2FF"
#> 
#> 
#> [[3]]
#> [[3]][[1]]
#> [1] 0.4
#> 
#> [[3]][[2]]
#> [1] "#ABBAE7"
#> 
#> 
#> [[4]]
#> [[4]][[1]]
#> [1] 0.6
#> 
#> [[4]][[2]]
#> [1] "#8394D0"
#> 
#> 
#> [[5]]
#> [[5]][[1]]
#> [1] 0.8
#> 
#> [[5]][[2]]
#> [1] "#5770B9"
#> 
#> 
#> [[6]]
#> [[6]][[1]]
#> [1] 1
#> 
#> [[6]][[2]]
#> [1] "#1F4FA3"
#> 
#> 
```
