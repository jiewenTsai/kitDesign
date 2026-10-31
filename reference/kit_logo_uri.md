# KIT logo (data URI)

Goes straight into the page (no static file path to set up). The logos
are transparent PNGs in `inst/logo/`.

## Usage

``` r
kit_logo_uri(size = 96, kind = c("mark", "logo"))
```

## Arguments

- size:

  Pixels: the bean (`"mark"`) comes in 64, 96, 256, `"h512"`, `"h1024"`;
  the full logo (`"logo"`, bean plus KIT wordmark) comes in 128, 192,
  `"h512"`, `"h1024"` (height). The header uses the vector logo
  ([`kit_logo_file()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_file.md));
  this function gives a PNG to embed in the page.

- kind:

  `"mark"` is the bean only (browser tab icon); `"logo"` is the full
  logo (header).

## Value

`"data:image/png;base64,..."`; `""` when that size does not exist.

## Examples

``` r
substr(kit_logo_uri(64), 1, 30)
#> [1] "data:image/png;base64,iVBORw0K"
```
