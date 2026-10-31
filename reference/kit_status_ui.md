# Status box

Renders a
[`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
as a status box: the first line is the label plus a one-sentence
conclusion; then up to 3 points (things to watch out for first, key
results after), the rest collapsed under "還有 N 點" ("N more points");
a button for what to do; small additional notes; the collapsed raw
message. After running, use
[`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md)
to scroll it to the top of the screen.

## Usage

``` r
kit_status_ui(st, ..., max_points = KIT_STATUS_MAX_POINTS)
```

## Arguments

- st:

  A
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  object (a list with the same fields, from older apps, also works);
  `NULL` or `"idle"` shows nothing.

- ...:

  Other content placed last inside the box (kitsUI's `ui_status(...)`).

- max_points:

  How many points to list directly (default 3).

## Value

`<div class="alert alert-success kit-status" role="alert">` or similar;
`NULL` when nothing is shown.

## Details

A `kit_status` object can also go straight into the page (its
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
method is this function); you only need to call this function to add
more content or change the number of points.

## Examples

``` r
kit_status_ui(kit_done_status(
  "串接完成：結果共 3,389 列 × 2,058 欄。",
  warnings = c("有 12 人的 ID 重複。", "第 3 波沒有 sex 欄。"),
  points = c("688 人每個檔案都有資料。", "第 1 波 3,389 人。")
))
#> <div class="alert alert-warning kit-status" role="alert">
#>   <div class="kit-status-line">
#>     <strong>【完成，但請注意】</strong>
#>      
#>     串接完成：結果共 3,389 列 × 2,058 欄。
#>   </div>
#>   <ul>
#>     <li>有 12 人的 ID 重複。</li>
#>     <li>第 3 波沒有 sex 欄。</li>
#>     <li>688 人每個檔案都有資料。</li>
#>   </ul>
#>   <details class="kit-status-more">
#>     <summary>還有 1 點</summary>
#>     <ul>
#>       <li>第 1 波 3,389 人。</li>
#>     </ul>
#>   </details>
#> </div>
```
