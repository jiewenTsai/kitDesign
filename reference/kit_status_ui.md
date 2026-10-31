# 狀態框（StatusBox）

把
[`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
畫成狀態框：第一行是標籤＋一句結論；接著最多 3 點
（要注意的事在前、結果的重點在後），其他收在「還有 N
點」；怎麼辦的按鈕； 補充小字；收起來的原始訊息。執行完用
[`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md)
把它捲到畫面上方。

## Usage

``` r
kit_status_ui(st, ..., max_points = KIT_STATUS_MAX_POINTS)
```

## Arguments

- st:

  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  物件（舊的 app 的同樣欄位的 list 也可以）；`NULL` 或 `"idle"`
  時不顯示。

- ...:

  其他放在框裡最後的內容（kitsUI 的 `ui_status(...)`）。

- max_points:

  直接列出幾點（預設 3）。

## Value

`<div class="alert alert-success kit-status" role="alert">`
等；不顯示時是 `NULL`。

## Details

`kit_status`
物件直接放進頁面也可以（[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
方法就是這個函式）； 要多放東西或改點數時才需要呼叫它。

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
