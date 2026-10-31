# 按鈕種類的 class

自己畫按鈕（例如
[`downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html)、`<a class="btn">`）時，用這裡的
class， 和
[`kit_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_button.md)
長得一樣。

## Usage

``` r
kit_btn_class(kind = c("secondary", "primary", "danger"))
```

## Arguments

- kind:

  `"primary"`（主要按鈕）、`"secondary"`（小按鈕）或
  `"danger"`（危險按鈕）。

## Value

class 字串，例如 `"btn-sm btn-outline-secondary"`。

## Examples

``` r
kit_btn_class("secondary")
#> [1] "btn-sm btn-outline-secondary"
```
