# Categorical chart colors

Colorblind-friendly Okabe–Ito. Cohorts, scales, and scores take colors
in order: blue, orange, green, reddish purple, sky blue, vermillion;
past 6 categories it starts over. For reference lines, bands, and points
with no judgment, use
[`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md).

## Usage

``` r
kit_chart_colors(n = NULL)
```

## Arguments

- n:

  When `NULL`, returns all 6 (named); when a number, takes the first `n`
  in order (unnamed).

## Value

A character vector of colors.

## Examples

``` r
kit_chart_colors()
#>       blue     orange      green     purple        sky vermillion 
#>  "#0072B2"  "#E69F00"  "#009E73"  "#CC79A7"  "#56B4E9"  "#D55E00" 
kit_chart_colors(3)
#> [1] "#0072B2" "#E69F00" "#009E73"
```
