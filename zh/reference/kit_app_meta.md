# 頁首的版本行，例如「kitJoin v0.6.0 · 2026-10-31」

版本行永遠在頁首，回報問題時用得到。先列套件、最後才是日期：app、`extra`（另一個主要套件，例如
kitsUI 的 kits：「kitsUI v0.8.3 · kits v0.25.2 ·
2026-11-02」）、`show_kitdesign = TRUE` 時的 kitDesign。每個版本前面都有
v。

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

  放在 app 後面、日期前面的字：另一個主要套件（例如
  `paste0("kits v", utils::packageVersion("kits"))`）。

- show_kitdesign:

  要不要在日期前面加「kitDesign
  v0.1.0」（[`kit_versions()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_versions.md)）。通常不用：kitDesign
  是模板，不是 app 的主要套件。

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
