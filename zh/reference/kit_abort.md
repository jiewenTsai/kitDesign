# 給使用者看的錯誤

訊息要是白話中文、說明原因與怎麼修；[`kit_error_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_error_status.md)
會原文顯示在狀態框，
不加技術細節。其他沒有預期到的錯誤則包成「…時發生沒有預期到的問題」，
原始訊息收起來。

## Usage

``` r
kit_abort(..., class = NULL, data = list())
```

## Arguments

- ...:

  訊息（用 [`paste0()`](https://rdrr.io/r/base/paste.html) 接起來）。

- class:

  另外加的 condition class（呼叫端可以另外處理，例如跳出確認視窗）。

- data:

  附在 condition 上的其他欄位（具名 list）。

## Value

不會回傳：丟出 `kit_user_error` 錯誤。

## Examples

``` r
e <- tryCatch(kit_abort("至少要 ", 2, " 個波次的檔案。"), error = identity)
class(e)
#> [1] "kit_user_error" "error"          "condition"     
conditionMessage(e)
#> [1] "至少要 2 個波次的檔案。"
```
