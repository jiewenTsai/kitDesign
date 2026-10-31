# htmlDependency for the logo files (inst/logo/): the header SVG and tab icon are fetched by URL

htmlDependency for the logo files (inst/logo/): the header SVG and tab
icon are fetched by URL.

## Usage

``` r
kit_logo_dependency()
```

## Value

An
[`htmltools::htmlDependency()`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)
object; file URLs are `kitDesign-logo-<version>/<file name>`
([`kit_logo_file()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_file.md)).

## Examples

``` r
kit_logo_dependency()$name
#> [1] "kitDesign-logo"
```
