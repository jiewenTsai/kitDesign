# KIT 的頁面：主題、樣式、頁首，一次設定好

包住
`bslib::page_fluid(lang = "zh-Hant-TW", theme = kit_theme(), use_kit(), kit_header(...), ...)`。
頁首下面接著放分頁列（[`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroups.md)
或
[`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_flow_tabs.md)）與各分頁的內容。

## Usage

``` r
kit_page(
  title,
  subtitle = NULL,
  ...,
  tagline = NULL,
  version = NULL,
  date = NULL,
  logo = TRUE,
  meta_extra = NULL,
  window_title = title,
  show_kitdesign = FALSE,
  brand = kit_current_brand(),
  package = NULL
)
```

## Arguments

- title:

  工具名稱（頁首的 h1，也是瀏覽器分頁的標題），例如「KIT
  資料串接工具」。

- subtitle:

  副標（粗體），例如資料庫名稱「臺灣幼兒發展調查資料庫」。

- ...:

  頁面的內容。

- tagline:

  接在副標後面的一句（例如「跨波次資料處理」）；`NULL` 不顯示。

- version, date:

  頁首版本行的版本與日期，通常讀 app 自己的 DESCRIPTION：
  `kit_app_description("kitJoin")`。

- logo:

  頁首要不要放品牌的標誌（KIT 的是豆子＋KIT 字樣）：`TRUE`（標誌檔由
  htmlDependency 提供，Shiny
  裡用）、`"inline"`（標誌直接寫進頁面，給沒有 Shiny 的 單一 HTML
  檔，例如使用手冊）、`FALSE`。

- meta_extra:

  版本行上的另一個主要套件，放在 app 後面、日期前面（例如「kits
  v0.25.0」：kitsUI 是介面，kits 是底下的計算）。

- window_title:

  瀏覽器分頁的標題（預設和 `title` 一樣）。

- show_kitdesign:

  要不要在日期前面加 kitDesign 的版本（「kitDesign
  v0.1.0」）。通常不用： kitDesign 是模板，不是 app 的主要套件。

- brand:

  品牌：標誌、分頁圖示、顏色（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)）。預設是
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_current_brand.md)：
  沒有設定 `options(kitDesign.brand = )` 時是 KIT。

- package:

  app 的套件名稱，寫在版本行最前面：「kitJoin v0.6.0 · 2026-10-31」。
  回報問題時一看就知道是哪個 app
  的哪一版。`NULL`（預設）不寫，和以前一樣。

## Value

一個完整的頁面（[`bslib::page_fluid()`](https://rstudio.github.io/bslib/reference/page.html)）。

## See also

[`kit_header()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_header.md)、[`kit_app_description()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_app_description.md)

## Examples

``` r
if (interactive()) {
  ui <- kit_page(
    "KIT ×× 工具", "臺灣幼兒發展調查資料庫",
    tagline = "跨波次資料處理", version = "0.1.0", date = "2026-10-31",
    kit_tab_guide("示範一頁。", kit_steps("選檔案", "按執行"), "一張表。")
  )
  shiny::shinyApp(ui, function(input, output, session) {})
}
```
