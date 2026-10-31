# plotly 圖附上 app 的字型（下載的 HTML 用）

在 plotly 圖上附一個 htmlDependency：向 Google Fonts 拿圓體 Chiron
GoRound TC （字重 400、700）。Shiny
的頁面已經有這個字型（[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)），所以這主要是給
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
存成的單一 HTML 檔用：打開時也是 app 的字型；沒有網路時退回 系統的
sans-serif。

## Usage

``` r
kit_plotly_fonts(p)
```

## Arguments

- p:

  plotly 圖（或其他 htmlwidget）。

## Value

同一張圖，多一個 htmlDependency（`kit-plotly-fonts`）。

## Details

`<link>` 帶 `data-external="1"`：`saveWidget(selfcontained = TRUE)` 用
pandoc 打包時不把 字型檔塞進
HTML（中文字型切成上百個檔，塞進去檔案會很大）。
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
預設（`fonts = TRUE`）已經呼叫它；同一張圖附兩次和附一次一樣。

## See also

[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)

## Examples

``` r
if (requireNamespace("plotly", quietly = TRUE)) {
  p <- kit_plotly_fonts(plotly::plot_ly(x = 1:3, y = c(2, 4, 3), type = "scatter", mode = "lines"))
  vapply(p$dependencies, function(d) d$name, "")
}
#> [1] "typedarray"             "jquery"                 "crosstalk"             
#> [4] "plotly-htmlwidgets-css" "plotly-main"            "kit-plotly-fonts"      
```
