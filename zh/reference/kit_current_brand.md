# 現在的品牌：`options(kitDesign.brand = )`，沒有設定時是 KIT

kitDesign
的函式（[`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)、[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)、[`kit_theme()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_theme.md)、[`kit_colors()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_colors.md)、
[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_chart_sequential.md)、[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_plotly_style.md)）的
`brand` 預設值。 app 只要在開始時設定一次
`options(kitDesign.brand = kit_brand(...))`。

## Usage

``` r
kit_current_brand()
```

## Value

`kit_brand` 物件。

## See also

[`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)

## Examples

``` r
kit_current_brand()$name
#> [1] "KIT"
```
