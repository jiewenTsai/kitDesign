# KIT 的 bslib 主題

以 Bootswatch Brite 為底（bslib 0.11.0 起才有），換成 KIT
的顏色；全文用圓體 Chiron GoRound TC，程式碼用 JetBrains
Mono。兩種字型都由瀏覽器向 Google Fonts 按需下載（`local = FALSE`）：CJK
字型切成上百個 unicode-range 片段， 避免伺服器啟動時抓下全部字檔。

## Usage

``` r
kit_theme(brand = kit_current_brand())
```

## Arguments

- brand:

  品牌（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)）；預設是
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)（沒有設定時是
  KIT）。

## Value

[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
物件。

## Details

通常不用自己呼叫：[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
已經用了它。

顏色從品牌來（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)）：`primary`、`success`、`navbar-bg`、`link-color`
是品牌的 `primary`，`link-hover-color` 是 `primary_hover`，`body-bg` 是
`page`，`border-color` 是 `ink`。
`info`、`warning`、`danger`、`secondary` 是 Bootstrap
自己用的深色，不跟著品牌換 （提示框、狀態框的底色在 CSS 的 `--nb-*`
變數裡，跟著品牌換）。 不讀
brand.yml（`bslib::bs_theme(brand = FALSE)`）：工作目錄或上層有
`_brand.yml` （例如 `brand/_brand.yml`）時，主題也不會跟著變。

## See also

[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)、[`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md)、[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)

## Examples

``` r
theme <- kit_theme()
bslib::theme_bootswatch(theme)
#> [1] "brite"
```
