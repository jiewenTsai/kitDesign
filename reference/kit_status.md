# Status object (status box)

The result of an action. This is an S3 value object (class
`kit_status`): its content is checked when it is built. It has an
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
method, so `renderUI(st)` or putting it straight into
[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
renders it as a status box (the same as
[`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md)).
`print(st)` prints a text version.

## Usage

``` r
kit_status(
  state = "idle",
  message = "",
  warnings = character(0),
  notes = character(0),
  details = NULL,
  action = NULL,
  points = character(0),
  details_title = "原始訊息"
)

# S3 method for class 'kit_status'
as.tags(x, ...)

# S3 method for class 'kit_status'
format(x, ...)

# S3 method for class 'kit_status'
print(x, ...)
```

## Arguments

- state:

  `"idle"`, `"success"`, `"warning"`, `"error"`, or `"stale"`.

- message:

  The conclusion on the first line (one sentence, with numbers and
  units): a string or tag.

- warnings:

  Things to watch out for (a character vector, or a list of strings and
  tags). Listed first.

- notes:

  Additional notes (small gray text).

- details:

  The raw message (R's original error text; collapsed): a string or
  `NULL`.

- action:

  A button or link for what to do (a tag); `NULL` shows nothing.

- points:

  Key results (listed after `warnings`; they do not turn the status into
  "請注意", "please note").

- details_title:

  The collapsible title for the raw message (kitsUI uses "kits 的原文",
  "kits' original text").

- x:

  A `kit_status` object.

- ...:

  Other content for
  [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md)
  (as.tags); not used by format and print.

## Value

A `kit_status` object.

## Details

Each of the four states has a fixed label and color:

|             |                                              |            |
|-------------|----------------------------------------------|------------|
| state       | Label                                        | Background |
| `"success"` | 【完成】 ("Done")                            | mint green |
| `"warning"` | 【完成，但請注意】 ("Done, but please note") | yellow     |
| `"error"`   | 【停下來】 ("Stopped")                       | salmon     |
| `"stale"`   | 【要重新執行】 ("Run again")                 | yellow     |

`"idle"` (not run yet) is not shown. kitsUI's names are also accepted:
`"done"`, `"warn"`, `"stop"`.

## See also

[`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md),
[`kit_done_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_done_status.md),
[`kit_error_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_error_status.md),
[`kit_stale_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_stale_status.md)

## Examples

``` r
st <- kit_status("success", "串接完成：結果共 3,389 列 × 2,058 欄。")
st
#> 【完成】 串接完成：結果共 3,389 列 × 2,058 欄。
htmltools::as.tags(st)
#> <div class="alert alert-success kit-status" role="alert">
#>   <div class="kit-status-line">
#>     <strong>【完成】</strong>
#>      
#>     串接完成：結果共 3,389 列 × 2,058 欄。
#>   </div>
#> </div>
```
