# Color scale for continuous values (chart)

Very light lime → light lime (`bg-new`) → KIT green (`nb-green`): larger
values are darker. For heatmaps and color bars (e.g. pass rates in a
response design plot). The minimum is not white, so 0 looks different
from an empty cell with no data (white background).
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
switches heatmaps to this scale by default.

## Usage

``` r
kit_chart_sequential(brand = kit_current_brand())
```

## Arguments

- brand:

  The brand
  ([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md));
  defaults to
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)
  (KIT when none is set).

## Value

A plotly colorscale:
`list(list(0, "#F3F7D3"), ..., list(1, "#006835"))`.

## Details

The scale comes from the brand
([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)):
0 is a very light color made by mixing `accent_light` with white, 0.2 is
`accent_light`, and 0.2 to 1 interpolates in Lab space from
`accent_light` to `primary`. For the KIT brand these are the values
above. Categorical colors
([`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md),
Okabe–Ito) do not change with the brand: they are colorblind-friendly.

## See also

[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md),
[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md)

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
