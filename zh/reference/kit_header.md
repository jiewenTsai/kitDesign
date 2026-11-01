# KIT 頁首

萊姆色塊、黑框、頁首陰影；左邊完整標誌，右邊工具名稱、一行副標、一行版本。
一個 app
只有一個，放在最上面（[`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)
已經放好了）。也會設定瀏覽器分頁的 圖示（KIT 是豆子標誌）。

## Usage

``` r
kit_header(
  title,
  subtitle = NULL,
  tagline = NULL,
  version = NULL,
  date = NULL,
  meta_extra = NULL,
  logo = TRUE,
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

- tagline:

  接在副標後面的一句（例如「跨波次資料處理」）；`NULL` 不顯示。

- version, date:

  頁首版本行的版本與日期，通常讀 app 自己的 DESCRIPTION：
  `kit_app_description("kitJoin")`。

- meta_extra:

  版本行後面再接的字（例如「kits 0.25.0」）。

- logo:

  頁首要不要放品牌的標誌（KIT 的是豆子＋KIT 字樣）：`TRUE`（標誌檔由
  htmlDependency 提供，Shiny
  裡用）、`"inline"`（標誌直接寫進頁面，給沒有 Shiny 的 單一 HTML
  檔，例如使用手冊）、`FALSE`。

- show_kitdesign:

  版本行後面要不要接 kitDesign 的版本（「kitDesign 0.1.0」），
  回報問題時兩個版本都看得到。

- brand:

  品牌：標誌、分頁圖示、顏色（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)）。預設是
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_current_brand.md)：
  沒有設定 `options(kitDesign.brand = )` 時是 KIT。

- package:

  app 的套件名稱，寫在版本行最前面：「kitJoin v0.6.0 · 2026-10-31」。
  回報問題時一看就知道是哪個 app
  的哪一版。`NULL`（預設）不寫，和以前一樣。

## Value

`<div class="kit-header mb-4">`。

## Details

標誌、分頁圖示、顏色從品牌來（[`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)）。品牌的顏色和
KIT 不同時，頁首另外放一小段 `<style>`，把不同的 `--nb-*` 變數換掉；KIT
的品牌不放，頁面和以前一樣。

## Examples

``` r
kit_header("KIT 資料串接工具", "臺灣幼兒發展調查資料庫", tagline = "跨波次資料處理",
           version = "0.6.0", date = "2026-10-31", package = "kitJoin")
#> <div class="kit-header mb-4">
#>   <div class="kit-header-row">
#>     <img src="kitDesign-logo-0.7.0/kit-logo.svg" alt="KIT 標誌" class="kit-header-logo"/>
#>     <div>
#>       <h1>KIT 資料串接工具</h1>
#>       <p>
#>         <span class="kit-subtitle">臺灣幼兒發展調查資料庫</span>
#>          · 
#>         跨波次資料處理
#>       </p>
#>       <div class="kit-app-meta">kitJoin v0.6.0 · 2026-10-31</div>
#>     </div>
#>   </div>
#> </div>
```
