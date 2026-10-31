# 品牌：標誌與顏色

kitDesign 預設是 KIT 的樣子。別的計畫或研究室要用 kitDesign 時，用
`kit_brand()` 換掉標誌與顏色；字型、框、陰影、元件的樣子照設計語言不變。
不給任何參數時就是 KIT（`kit_brand()`），畫出來的頁面和以前一模一樣。

## Usage

``` r
kit_brand(
  name = "KIT",
  logo = NULL,
  mark = NULL,
  logo_alt = NULL,
  colors = list()
)
```

## Arguments

- name:

  品牌名稱，例如 `"KIT"`、`"示範實驗室"`。

- logo:

  頁首標誌的檔案路徑（SVG 或 PNG）；`NULL` 見上面；`FALSE` 不放標誌。

- mark:

  瀏覽器分頁圖示的檔案路徑（SVG 或 PNG，方形）；`NULL` 時用 `logo`。

- logo_alt:

  標誌的替代文字；`NULL` 時是「KIT 標誌」（KIT）或「 標誌」。

- colors:

  要換的顏色：具名 list 或具名字串向量，名稱見上表，值是 `"#RRGGBB"` 或
  R 認得的顏色名稱。不認得的名稱會停下來，列出可以用的名稱。

## Value

`kit_brand` 物件（list：`name`、`logo_alt`、`colors`（11 個
`#rrggbb`）、標誌檔）。

## Details

品牌交給
[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)（`brand =`），或在
app 開始時設定一次： `options(kitDesign.brand = kit_brand(...))`，之後
[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)、[`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md)、
[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)、[`kit_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_colors.md)、[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)、[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
都用它（[`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)）。

**顏色**（`colors`）用設計語言的名稱，沒有給的照 KIT：

|  |  |  |  |
|----|----|----|----|
| 名稱 | CSS 變數 | KIT | 用在 |
| `ink` | `--nb-ink` | `#141414` | 文字、框、陰影 |
| `page` | `--nb-page` | `#faf7f0` | 整頁背景 |
| `card` | `--nb-card` | `#ffffff` | 卡片、輸入框、表格 |
| `accent` | `--nb-lime` | `#c6d033` | 主角色塊：頁首、主要按鈕、目前的分頁 |
| `accent_light` | `--nb-bg-new` | `#e8f0a0` | 淡的主角色：圖解裡新加的欄、色階的淡端 |
| `primary` | `--nb-green` | `#006835` | 連結、勾選框、進度條、色階的深端 |
| `primary_hover` | `--nb-green-hover` | `#004d27` | 連結滑過 |
| `success` | `--nb-mint` | `#b9f0a8` | 【完成】 |
| `warning` | `--nb-yellow` | `#ffde59` | 【完成，但請注意】 |
| `danger` | `--nb-salmon` | `#ff9b8f` | 【停下來】、危險按鈕 |
| `info` | `--nb-sky` | `#a8dcff` | 資訊提示框 |

只給 `accent` 時，`accent_light` 由它算出來（和白色混合）；只給
`primary` 時， `primary_hover` 由它算出來（加深）。色塊上的字一律是
`ink`：選 `accent` 與四個狀態色時， 確認 `ink` 在上面的對比至少
4.5:1；`primary` 是文字色，在 `page` 上也要 4.5:1。

**標誌**：`logo` 是頁首的完整標誌，`mark`
是瀏覽器分頁的小圖示（方形；沒有給時用 `logo`）。都是 SVG 或 PNG
檔的路徑；檔案在建立品牌時讀進來，所以之後換工作目錄也沒關係。 在 Shiny
裡由一個只有這兩個檔的 htmlDependency 提供（不會公開檔案所在的資料夾）；
`kit_header(logo = "inline")` 時寫成 data URI。 `name = "KIT"`
而且沒有給 `logo` 時用 KIT 的標誌；其他名稱沒有給 `logo`
時，頁首不放標誌。 `logo = FALSE` 一律不放標誌。

## See also

[`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)、[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)、[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)、[`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)

## Examples

``` r
kit_brand()
#> <kit_brand> KIT
#>   logo: kit-logo.svg (kitDesign)  (alt: KIT 標誌)
#>   mark: kit-mark.svg (kitDesign), kit-mark-64.png (kitDesign)
#>   colors (* = not KIT):
#>     ink            #141414
#>     page           #faf7f0
#>     card           #ffffff
#>     accent         #c6d033
#>     accent_light   #e8f0a0
#>     primary        #006835
#>     primary_hover  #004d27
#>     success        #b9f0a8
#>     warning        #ffde59
#>     danger         #ff9b8f
#>     info           #a8dcff

# 別的研究室：藍色系、自己的標誌
demo <- kit_brand(
  "示範實驗室",
  logo = system.file("examples", "brand", "demo-logo.svg", package = "kitDesign"),
  mark = system.file("examples", "brand", "demo-mark.svg", package = "kitDesign"),
  colors = list(accent = "#9cc0ff", primary = "#1f4fa3", page = "#f5f7fa")
)
demo
#> <kit_brand> 示範實驗室
#>   logo: demo-logo.svg  (alt: 示範實驗室 標誌)
#>   mark: demo-mark.svg
#>   colors (* = not KIT):
#>     ink            #141414
#>     page           #f5f7fa  *
#>     card           #ffffff
#>     accent         #9cc0ff  *
#>     accent_light   #d4e2ff  *
#>     primary        #1f4fa3  *
#>     primary_hover  #1f3b77  *
#>     success        #b9f0a8
#>     warning        #ffde59
#>     danger         #ff9b8f
#>     info           #a8dcff
if (interactive()) {
  options(kitDesign.brand = demo)   # 整個 app 用這個品牌
  kit_gallery()
}
```
