# URL of a logo file (for use on the page)

Used for both the header's vector logo and the tab icon; the URL is
served by
[`kit_logo_dependency()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_dependency.md)
(the page must include this dependency:
[`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md)
already attaches it). To embed the logo in the page without a separate
file, use
[`kit_logo_uri()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_uri.md)
(a PNG data URI).

## Usage

``` r
kit_logo_file(file = "kit-logo.svg")
```

## Arguments

- file:

  A file name in `inst/logo/`: `"kit-logo.svg"` (full logo),
  `"kit-mark.svg"` (the bean), or a PNG (`"kit-mark-64.png"`,
  `"kit-logo-h512.png"`…).

## Value

A relative URL, e.g. `"kitDesign-logo-0.1.0/kit-logo.svg"`.

## Examples

``` r
kit_logo_file("kit-logo.svg")
#> [1] "kitDesign-logo-0.5.1/kit-logo.svg"
```
