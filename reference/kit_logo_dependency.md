# 標誌檔（inst/logo/）的 htmlDependency：頁首的 SVG 與分頁圖示用網址取得

標誌檔（inst/logo/）的 htmlDependency：頁首的 SVG 與分頁圖示用網址取得

## Usage

``` r
kit_logo_dependency()
```

## Value

[`htmltools::htmlDependency()`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)
物件；檔案的網址是 `kitDesign-logo-<版本>/<檔名>`
（[`kit_logo_file()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_file.md)）。

## Examples

``` r
kit_logo_dependency()$name
#> [1] "kitDesign-logo"
```
