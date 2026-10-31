# Charts

Pass a plotly chart drawn by kits (for example
`plot(item, type = "category")`) to
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
as the last step: font, axis lines, grid lines, background, title,
legend, color bar, hover labels, and toolbar all take the KIT look. **It
changes only the look, not the data**: points, lines, axis ranges,
ticks, and hover text stay as they are.

## Before and after

Left: the original chart. Right: after
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md).

**Category probability curves** (small multiples: the black frame around
each panel becomes a light line, and there are no frames inside frames)

![Category probability curves: the original look on the left, after
kit_plotly_style() on the right](figures/chart-category.jpg)

**Response design chart** (heat map: switched to the KIT color scale)

![Response design chart: the original color scale on the left, KIT's
light lime to KIT green on the right](figures/chart-design.jpg)

**Wright map**

![Wright map: the original look on the left, after styling on the
right](figures/chart-wright.jpg)

The lowest value in a heat map is not white, so 0% cells and cells that
were not administered (blank) are easy to tell apart.

![Heat map: 0% is a very light lime, cells with no data are
white](figures/chart-heat-zero.jpg)

## How to use it

``` r

library(kitDesign)

p <- plotly::plot_ly(d, x = ~wave, y = ~score, split = ~cohort,
                     type = "scatter", mode = "lines+markers")
p <- plotly::layout(p, title = "各世代的分數中位數")  # "Median score by cohort"
kit_plotly_style(p)
```

## With kits and kitsUI: the order

1.  Draw the chart with kits’
    [`plot()`](https://rdrr.io/r/graphics/plot.default.html).
2.  Recolor with kitsUI: `kit_chart_categorical()`, `kit_chart_role()`.
3.  Switch to Chinese labels with kitsUI: `kit_chart_zh()`. **This must
    come before
    [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)**:
    [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
    makes titles bold (`<b>`), and after that the original English
    titles can no longer be recognized.
4.  [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
    last.

``` r

p <- plot(item, type = "category")              # 1. kits
p <- kit_chart_zh(kit_chart_categorical(p))     # 2–3. kitsUI: recolor, Chinese labels
kit_plotly_style(p)                             # 4. last
```

Styling the same chart twice gives the same result as styling it once.
Colors set by kits or kitsUI are kept; only plotly’s own default colors
are replaced with Okabe–Ito (colorblind-friendly).

## Common options

| Argument | What it does |
|----|----|
| `legend = "auto"` | Moves the legend to the bottom when it has more than 4 entries or is too long, or when the chart is narrower than 600px (phones); also `"bottom"`, `"right"`, `"keep"` |
| `colorscale = FALSE` | Keeps the heat map’s original color scale |
| `filename = "kit-chart"` | File name for the toolbar’s “Download as PNG” |
| `font_size = 15` | Body text size (px); other sizes are derived from it |
| `brand =` | Heat map color scale follows the brand (see [Using another brand](https://jiewentsai.github.io/kitDesign/articles/brand.md)) |

Colors: categorical colors
[`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md),
reference lines
[`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md),
continuous values
[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md).
