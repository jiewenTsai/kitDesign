# Status for a failed run (【停下來】, stopped)

Plain-language errors from
[`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
are shown directly; for unexpected errors it says what to do, and the
original message is tucked inside "原始訊息" ("Original message").

## Usage

``` r
kit_error_status(e, action, todo = NULL)
```

## Arguments

- e:

  The error (a condition).

- action:

  The action name, e.g. "串接" ("join").

- todo:

  A button or link for what to do (a tag); `NULL` shows nothing.

## Value

A `kit_status` object.

## Examples

``` r
e <- tryCatch(stop("object 'x' not found"), error = identity)
kit_error_status(e, "串接")
#> 【停下來】 串接時發生沒有預期到的問題，沒有做完。
#> - 怎麼辦：確認檔案內容與設定後再試一次；一直發生的話，請把下面的「原始訊息」回報給開發者。
#>   原始訊息：object 'x' not found
u <- tryCatch(kit_abort("至少要 2 個波次的檔案。"), error = identity)  # "Need files from at least 2 waves."
kit_error_status(u, "串接")$message
#> [1] "至少要 2 個波次的檔案。"
```
