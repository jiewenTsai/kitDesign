# The version line in the header, e.g. "kitJoin v0.6.0 · 2026-10-31"

The version line always sits in the header; it is needed when reporting
problems. The packages come first, then the date: the app, `extra`
(another main package, such as kits for kitsUI: "kitsUI v0.8.3 · kits
v0.25.2 · 2026-11-02"), then kitDesign when `show_kitdesign = TRUE`.
Every version is written with "v".

## Usage

``` r
kit_app_meta(
  version = NULL,
  date = NULL,
  extra = NULL,
  show_kitdesign = FALSE,
  package = NULL
)
```

## Arguments

- version:

  The version ("v" is added in front); `NULL` or `NA` shows nothing.

- date:

  The date; `NULL` or `NA` shows nothing.

- extra:

  Text placed after the app and before the date: another main package
  (e.g. `paste0("kits v", utils::packageVersion("kits"))`).

- show_kitdesign:

  Whether to add "kitDesign v0.1.0"
  ([`kit_versions()`](https://jiewentsai.github.io/kitDesign/reference/kit_versions.md)).
  Usually not needed: kitDesign is the template, not one of the app's
  main packages.

- package:

  The app's package name, written before the version ("kitJoin v0.6.0");
  `NULL` writes no name.

## Value

`<div class="kit-app-meta">`; `NULL` when all three are missing.

## Examples

``` r
kit_app_meta("0.5.0", "2026-10-31")
#> <div class="kit-app-meta">v0.5.0 · 2026-10-31</div>
kit_app_meta("0.6.0", "2026-10-31", package = "kitJoin")
#> <div class="kit-app-meta">kitJoin v0.6.0 · 2026-10-31</div>
```
