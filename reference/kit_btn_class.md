# Class for a button kind

When you build a button yourself (e.g.
[`downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html),
`<a class="btn">`), use this class so it looks the same as
[`kit_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_button.md).

## Usage

``` r
kit_btn_class(kind = c("secondary", "primary", "danger"))
```

## Arguments

- kind:

  `"primary"` (primary button), `"secondary"` (secondary button), or
  `"danger"` (danger button).

## Value

A class string, e.g. `"btn-sm btn-outline-secondary"`.

## Examples

``` r
kit_btn_class("secondary")
#> [1] "btn-sm btn-outline-secondary"
```
