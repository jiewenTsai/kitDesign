# 執行失敗的狀態（【停下來】）

[`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
的白話錯誤直接顯示；沒有預期到的錯誤寫「怎麼辦」，
原始訊息收在「原始訊息」裡。

## Usage

``` r
kit_error_status(e, action, todo = NULL)
```

## Arguments

- e:

  錯誤（condition）。

- action:

  動作名稱，例如「串接」。

- todo:

  怎麼辦的按鈕或連結（tag）；`NULL` 不顯示。

## Value

`kit_status` 物件。

## Examples

``` r
e <- tryCatch(stop("object 'x' not found"), error = identity)
kit_error_status(e, "串接")
#> 【停下來】 串接時發生沒有預期到的問題，沒有做完。
#> - 怎麼辦：確認檔案內容與設定後再試一次；一直發生的話，請把下面的「原始訊息」回報給開發者。
#>   原始訊息：object 'x' not found
u <- tryCatch(kit_abort("至少要 2 個波次的檔案。"), error = identity)
kit_error_status(u, "串接")$message
#> [1] "至少要 2 個波次的檔案。"
```
