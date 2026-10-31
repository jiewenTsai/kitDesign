# 版本：kitDesign 與 app 自己的

回報問題時，兩個版本都要寫。頁首的版本行可以接上 kitDesign 的版本：
`kit_page(..., show_kitdesign = TRUE)` →「v0.5.0 · 2026-10-31 ·
kitDesign 0.1.0」。

## Usage

``` r
kit_versions(package = NULL)
```

## Arguments

- package:

  app 的套件名稱（例如 `"kitJoin"`）；`NULL` 時只有 kitDesign。
  版本讀法和
  [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_description.md)
  一樣。

## Value

具名字串向量，例如 `c(kitDesign = "0.1.0", kitJoin = "0.5.0")`。

## Examples

``` r
kit_versions()
#> kitDesign 
#>   "0.5.0" 
```
