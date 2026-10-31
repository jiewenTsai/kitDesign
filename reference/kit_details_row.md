# 一排細節（Details）

結果下面一排收起來的小字標題（▸ 預覽　▸ 這一回合的紀錄　▸ 用 R
怎麼做）； 打開的那一個佔一整行，內容不加框。「用 R
怎麼做」永遠放在最後一個。

## Usage

``` r
kit_details_row(...)
```

## Arguments

- ...:

  [`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md)（或
  [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)）。

## Value

`<div class="kit-details">`。

## Examples

``` r
kit_details_row(
  kit_detail("預覽", "前 10 列"),
  kit_detail("這一回合的紀錄", "沒有提醒。")
)
#> <div class="kit-details">
#>   <details class="kit-detail">
#>     <summary>預覽</summary>
#>     <div class="kit-detail-body">前 10 列</div>
#>   </details>
#>   <details class="kit-detail">
#>     <summary>這一回合的紀錄</summary>
#>     <div class="kit-detail-body">沒有提醒。</div>
#>   </details>
#> </div>
```
