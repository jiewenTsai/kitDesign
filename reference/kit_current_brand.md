# The current brand: `options(kitDesign.brand = )`, KIT when not set

The default `brand` for kitDesign functions
([`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md),
[`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md),
[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md),
[`kit_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_colors.md),
[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md),
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)).
An app only needs to set `options(kitDesign.brand = kit_brand(...))`
once at startup.

## Usage

``` r
kit_current_brand()
```

## Value

A `kit_brand` object.

## See also

[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)

## Examples

``` r
kit_current_brand()$name
#> [1] "KIT"
```
