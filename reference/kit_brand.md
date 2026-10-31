# Brand: logo and colors

kitDesign looks like KIT by default. When another project or lab uses
kitDesign, `kit_brand()` swaps the logo and colors; typeface, borders,
shadows, and how components look follow the design language and stay the
same. With no arguments it is KIT (`kit_brand()`), and pages look
exactly as before.

## Usage

``` r
kit_brand(
  name = "KIT",
  logo = NULL,
  mark = NULL,
  logo_alt = NULL,
  colors = list()
)
```

## Arguments

- name:

  The brand name, e.g. `"KIT"`, `"示範實驗室"` ("Demo Lab").

- logo:

  Path to the header logo file (SVG or PNG); for `NULL` see above;
  `FALSE` shows no logo.

- mark:

  Path to the browser tab icon file (SVG or PNG, square); when `NULL`,
  `logo` is used.

- logo_alt:

  Alt text for the logo; when `NULL`, "KIT 標誌" ("KIT logo") for KIT,
  or " 標誌" ("\<name\> logo").

- colors:

  Colors to replace: a named list or named character vector; names are
  in the table above, values are `"#RRGGBB"` or color names R knows. An
  unknown name stops with an error listing the names you can use.

## Value

A `kit_brand` object (a list: `name`, `logo_alt`, `colors` (11 `#rrggbb`
values), and the logo files).

## Details

Pass the brand to
[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
(`brand =`), or set it once when the app starts:
`options(kitDesign.brand = kit_brand(...))`. After that
[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md),
[`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md),
[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md),
[`kit_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_colors.md),
[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md),
and
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
all use it
([`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)).

**Colors** (`colors`) use the design-language names; anything not given
follows KIT:

|  |  |  |  |
|----|----|----|----|
| Name | CSS variable | KIT | Used for |
| `ink` | `--nb-ink` | `#141414` | text, borders, shadows |
| `page` | `--nb-page` | `#faf7f0` | page background |
| `card` | `--nb-card` | `#ffffff` | cards, inputs, tables |
| `accent` | `--nb-lime` | `#c6d033` | main color block: header, primary button, current tab |
| `accent_light` | `--nb-bg-new` | `#e8f0a0` | light main color: new columns in diagrams, light end of the color scale |
| `primary` | `--nb-green` | `#006835` | links, checkboxes, progress bars, dark end of the color scale |
| `primary_hover` | `--nb-green-hover` | `#004d27` | link hover |
| `success` | `--nb-mint` | `#b9f0a8` | \[done\] |
| `warning` | `--nb-yellow` | `#ffde59` | \[done, but take note\] |
| `danger` | `--nb-salmon` | `#ff9b8f` | \[stopped\], danger button |
| `info` | `--nb-sky` | `#a8dcff` | info callout |

If only `accent` is given, `accent_light` is derived from it (mixed with
white); if only `primary` is given, `primary_hover` is derived from it
(darkened). Text on color blocks is always `ink`: when choosing `accent`
and the four status colors, check that `ink` on them has at least 4.5:1
contrast; `primary` is a text color and also needs 4.5:1 on `page`.

**Logo**: `logo` is the full header logo, `mark` is the small browser
tab icon (square; when not given, `logo` is used). Both are paths to SVG
or PNG files; the files are read when the brand is created, so changing
the working directory later does not matter. In Shiny they are served by
an htmlDependency containing only these two files (the folder they live
in is not exposed); with `kit_header(logo = "inline")` they are written
as a data URI. With `name = "KIT"` and no `logo`, the KIT logo is used;
with any other name and no `logo`, the header has no logo.
`logo = FALSE` never shows a logo.

## See also

[`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md),
[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md),
[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md),
[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)

## Examples

``` r
kit_brand()
#> <kit_brand> KIT
#>   logo: kit-logo.svg (kitDesign)  (alt: KIT 標誌)
#>   mark: kit-mark.svg (kitDesign), kit-mark-64.png (kitDesign)
#>   colors (* = not KIT):
#>     ink            #141414
#>     page           #faf7f0
#>     card           #ffffff
#>     accent         #c6d033
#>     accent_light   #e8f0a0
#>     primary        #006835
#>     primary_hover  #004d27
#>     success        #b9f0a8
#>     warning        #ffde59
#>     danger         #ff9b8f
#>     info           #a8dcff

# Another lab: blue colors, its own logo
demo <- kit_brand(
  "示範實驗室",
  logo = system.file("examples", "brand", "demo-logo.svg", package = "kitDesign"),
  mark = system.file("examples", "brand", "demo-mark.svg", package = "kitDesign"),
  colors = list(accent = "#9cc0ff", primary = "#1f4fa3", page = "#f5f7fa")
)
demo
#> <kit_brand> 示範實驗室
#>   logo: demo-logo.svg  (alt: 示範實驗室 標誌)
#>   mark: demo-mark.svg
#>   colors (* = not KIT):
#>     ink            #141414
#>     page           #f5f7fa  *
#>     card           #ffffff
#>     accent         #9cc0ff  *
#>     accent_light   #d4e2ff  *
#>     primary        #1f4fa3  *
#>     primary_hover  #1f3b77  *
#>     success        #b9f0a8
#>     warning        #ffde59
#>     danger         #ff9b8f
#>     info           #a8dcff
if (interactive()) {
  options(kitDesign.brand = demo)   # use this brand for the whole app
  kit_gallery()
}
```
