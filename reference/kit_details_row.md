# Details row

A row of collapsed small-print titles below the result (▸ 預覽 ▸
這一回合的紀錄 ▸ 用 R 怎麼做; "Preview", "Log for this round", "How to
do it in R"). The one that is open takes a full line, and its content
has no box. "用 R 怎麼做" ("How to do it in R") always goes last.

## Usage

``` r
kit_details_row(...)
```

## Arguments

- ...:

  [`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md)
  (or
  [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)).

## Value

`<div class="kit-details">`.

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
# "Preview" / "First 10 rows"; "Log for this round" / "No notes."
```
