# KIT styles and browser-side scripts (an htmltools dependency)

Can go anywhere in the page (htmltools moves it into `<head>`). It
contains:

## Usage

``` r
use_kit()
```

## Value

An
[`htmltools::htmlDependency()`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)
object.

## Details

- `kit-base.css`: basic styles for the header, guide boxes, callouts,
  and so on (formerly `kit_css()`, `kit_css_guide()`).

- `kit-brite.css`: KIT's neo-brutalism styles (formerly
  `kit_css_brite()`).

- `kit-design.css`: the few rules kitDesign adds (header layout, dashed
  tabs in flow tabs, code box width).

- `kit.js`: collapsible sections, tab bars, tab states, scrolling to
  results, the reminder before leaving, and the "複製" ("Copy") button.

[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
already adds it; you only need to add `use_kit()` when you build the
page yourself with `bslib::page_*()`, and pass `theme = kit_theme()` to
the page.

## Examples

``` r
use_kit()
#> List of 10
#>  $ name      : chr "kitDesign"
#>  $ version   : chr "0.6.0"
#>  $ src       :List of 1
#>   ..$ file: chr "www"
#>  $ meta      : NULL
#>  $ script    : chr "kit.js"
#>  $ stylesheet: chr [1:3] "kit-base.css" "kit-brite.css" "kit-design.css"
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : chr "kitDesign"
#>  $ all_files : logi FALSE
#>  - attr(*, "class")= chr "html_dependency"
```
