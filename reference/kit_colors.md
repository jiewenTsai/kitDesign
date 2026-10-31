# KIT 品牌色常數（供自訂 CSS 或圖表使用）

和 kitJoin、kitsUI 的 `kit_colors()` 相同的名稱。介面元件的顏色在 CSS 的
tokens 裡 （`var(--nb-lime)` 等，見 `brand/KIT設計語言.md` 的附錄）。
`primary`、`accent`、`subtitle`
從品牌來（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)
的 `primary`、`accent`、 `accent_light`），`primary_light` 是 `primary`
調淡；其他是固定的中性色與舊的提示色。

## Usage

``` r
kit_colors(brand = kit_current_brand())
```

## Arguments

- brand:

  品牌（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)）；預設是
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)（沒有設定時是
  KIT）。

## Value

具名 list。

## Examples

``` r
kit_colors()$primary
#> [1] "#006835"
```
