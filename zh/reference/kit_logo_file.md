# 標誌檔的網址（頁面上用）

頁首的向量標誌與分頁圖示都用它；網址由
[`kit_logo_dependency()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_logo_dependency.md)
提供 （頁面要有這個
dependency：[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)
已經附上了）。 要嵌進頁面、不另外取檔時，用
[`kit_logo_uri()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_logo_uri.md)（PNG
的 data URI）。

## Usage

``` r
kit_logo_file(file = "kit-logo.svg")
```

## Arguments

- file:

  `inst/logo/`
  裡的檔名：`"kit-logo.svg"`（完整標誌）、`"kit-mark.svg"`（豆子）、 或
  PNG（`"kit-mark-64.png"`、`"kit-logo-h512.png"`…）。

## Value

相對網址，例如 `"kitDesign-logo-0.1.0/kit-logo.svg"`。

## Examples

``` r
kit_logo_file("kit-logo.svg")
#> [1] "kitDesign-logo-0.7.0/kit-logo.svg"
```
