# KIT's bslib theme

Based on Bootswatch Brite (available from bslib 0.11.0), with KIT's
colors; all text uses the rounded typeface Chiron GoRound TC, code uses
JetBrains Mono. Both typefaces are downloaded by the browser from Google
Fonts on demand (`local = FALSE`): CJK typefaces are split into hundreds
of unicode-range pieces, so the server does not fetch every font file at
startup.

## Usage

``` r
kit_theme(brand = kit_current_brand())
```

## Arguments

- brand:

  The brand
  ([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md));
  defaults to
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)
  (KIT when not set).

## Value

A
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
object.

## Details

You usually do not need to call it yourself:
[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
already uses it.

Colors come from the brand
([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)):
`primary`, `success`, `navbar-bg`, and `link-color` are the brand's
`primary`; `link-hover-color` is `primary_hover`; `body-bg` is `page`;
`border-color` is `ink`. `info`, `warning`, `danger`, and `secondary`
are Bootstrap's own dark colors and do not change with the brand (the
background colors of callouts and status boxes are in the CSS `--nb-*`
variables, which do change with the brand). brand.yml is not read
(`bslib::bs_theme(brand = FALSE)`): when the working directory or a
parent has a `_brand.yml` (for example `brand/_brand.yml`), the theme
does not change.

## See also

[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md),
[`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md),
[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)

## Examples

``` r
theme <- kit_theme()
bslib::theme_bootswatch(theme)
#> [1] "brite"
```
