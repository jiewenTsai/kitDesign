# Attach the app's typeface to a plotly chart (for downloaded HTML)

Attaches an htmlDependency to a plotly chart that loads the rounded
typeface Chiron GoRound TC from Google Fonts (weights 400 and 700).
Shiny pages already have this typeface
([`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)),
so this is mainly for single HTML files saved with
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html):
they also open in the app's typeface; without a network connection they
fall back to the system sans-serif.

## Usage

``` r
kit_plotly_fonts(p)
```

## Arguments

- p:

  A plotly chart (or another htmlwidget).

## Value

The same chart, with one more htmlDependency (`kit-plotly-fonts`).

## Details

The `<link>` carries `data-external="1"`: when
`saveWidget(selfcontained = TRUE)` bundles the file with pandoc, the
font files are not embedded in the HTML (a Chinese typeface is split
into hundreds of files, so embedding them would make the file very
large).
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
already calls it by default (`fonts = TRUE`); attaching it twice to the
same chart is the same as attaching it once.

## See also

[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)

## Examples

``` r
if (requireNamespace("plotly", quietly = TRUE)) {
  p <- kit_plotly_fonts(plotly::plot_ly(x = 1:3, y = c(2, 4, 3), type = "scatter", mode = "lines"))
  vapply(p$dependencies, function(d) d$name, "")
}
#> [1] "typedarray"             "jquery"                 "crosstalk"             
#> [4] "plotly-htmlwidgets-css" "plotly-main"            "kit-plotly-fonts"      
```
