# 頁首的版本行，例如「kitJoin v0.6.0 · 2026-10-31」

版本行永遠在頁首，回報問題時用得到。

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

  版本（前面自動加「v」）；`NULL` 或 `NA` 不顯示。

- date:

  日期；`NULL` 或 `NA` 不顯示。

- extra:

  後面再接的字（例如 `paste("kits", utils::packageVersion("kits"))`）。

- show_kitdesign:

  後面要不要接「kitDesign
  0.1.0」（[`kit_versions()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_versions.md)）。

- package:

  app 的套件名稱，寫在版本前面（「kitJoin v0.6.0」）；`NULL` 不寫。

## Value

`<div class="kit-app-meta">`；三樣都沒有時是 `NULL`。

## Examples

``` r
kit_app_meta("0.5.0", "2026-10-31")
#> <div class="kit-app-meta">v0.5.0 · 2026-10-31</div>
kit_app_meta("0.6.0", "2026-10-31", package = "kitJoin")
#> <div class="kit-app-meta">kitJoin v0.6.0 · 2026-10-31</div>
```
