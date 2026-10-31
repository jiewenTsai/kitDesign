# KIT 標誌（data URI）

直接放進頁面（不用另外設定靜態檔案的路徑）。標誌是透明底 PNG，在
`inst/logo/`。

## Usage

``` r
kit_logo_uri(size = 96, kind = c("mark", "logo"))
```

## Arguments

- size:

  像素：豆子（`"mark"`）有
  64、96、256、`"h512"`、`"h1024"`；完整標誌（`"logo"`， 豆子＋KIT
  字樣）有 128、192、`"h512"`、`"h1024"`（高度）。頁首用的是向量標誌
  （[`kit_logo_file()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_file.md)），這個函式給要嵌進頁面的
  PNG。

- kind:

  `"mark"` 只有豆子（瀏覽器分頁圖示）；`"logo"` 完整標誌（頁首）。

## Value

`"data:image/png;base64,..."`；沒有這個大小時是 `""`。

## Examples

``` r
substr(kit_logo_uri(64), 1, 30)
#> [1] "data:image/png;base64,iVBORw0K"
```
