# 執行完的狀態：有要注意的事時是【完成，但請注意】，否則是【完成】

異常一定要被看見：有 `warnings` 時，狀態就不能是單純的【完成】。

## Usage

``` r
kit_done_status(
  message,
  warnings = character(0),
  notes = character(0),
  points = character(0)
)
```

## Arguments

- message:

  第一行的結論（一句話，帶數字與單位）：一個字串或 tag。

- warnings:

  需要注意的事（字串向量，或字串與 tag 的 list）。排在最前面。

- notes:

  補充說明（灰色小字）。

- points:

  結果的重點（排在 `warnings` 後面；不會讓狀態變成「請注意」）。

## Value

`kit_status` 物件。

## Examples

``` r
kit_done_status("串接完成：3,389 人。")
#> 【完成】 串接完成：3,389 人。
kit_done_status("串接完成：3,389 人。", warnings = "有 12 人的 ID 重複，只留第一筆。")
#> 【完成，但請注意】 串接完成：3,389 人。
#> - 有 12 人的 ID 重複，只留第一筆。
```
