# KIT brand color constants (for custom CSS or charts)

Same names as `kit_colors()` in kitJoin and kitsUI. Colors for UI
components are in the CSS tokens (`var(--nb-lime)` etc.; see the
appendix of `brand/en/design-language.md`). `primary`, `accent`, and
`subtitle` come from the brand (`primary`, `accent`, and `accent_light`
in
[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md));
`primary_light` is a lighter `primary`; the rest are fixed neutrals and
older alert colors.

## Usage

``` r
kit_colors(brand = kit_current_brand())
```

## Arguments

- brand:

  The brand
  ([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md));
  defaults to
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)
  (KIT when none is set).

## Value

A named list.

## Examples

``` r
kit_colors()$primary
#> [1] "#006835"
```
