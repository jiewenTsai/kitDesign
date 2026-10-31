# Component gallery app

One app holding every component, filled with KIT examples. The source is
in `system.file("examples/gallery", package = "kitDesign")`.

## Usage

``` r
kit_gallery(..., brand = NULL)
```

## Arguments

- ...:

  Arguments passed to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html) (e.g.
  `port = 7551`, `launch.browser = FALSE`).

- brand:

  Which brand to view: `NULL` (default) is the current brand
  ([`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md),
  usually KIT); `"demo"` is a blue demo brand (to see how a different
  brand looks); or a
  [`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md).

## Value

The result of
[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html) (when the
app closes).

## Examples

``` r
if (interactive()) kit_gallery()
if (interactive()) kit_gallery(brand = "demo")
```
