# Versions: kitDesign and the app's own

When reporting a problem, include both versions. The header's version
line can include the kitDesign version:
`kit_page(..., show_kitdesign = TRUE)` → "v0.5.0 · 2026-10-31 ·
kitDesign 0.1.0".

## Usage

``` r
kit_versions(package = NULL)
```

## Arguments

- package:

  The app's package name (for example `"kitJoin"`); with `NULL`, only
  kitDesign. Versions are read the same way as
  [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_description.md).

## Value

A named character vector, for example
`c(kitDesign = "0.1.0", kitJoin = "0.5.0")`.

## Examples

``` r
kit_versions()
#> kitDesign 
#>   "0.5.0" 
```
