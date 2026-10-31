# The version line in the header, e.g. "kitJoin v0.6.0 · 2026-10-31"

The version line always sits in the header; it is needed when reporting
problems.

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

  Text to append (e.g. `paste("kits", utils::packageVersion("kits"))`).

- show_kitdesign:

  Whether to append "kitDesign 0.1.0"
  ([`kit_versions()`](https://jiewentsai.github.io/kitDesign/reference/kit_versions.md)).

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
