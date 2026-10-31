# 狀態物件（StatusBox）

一個動作的結果。這是一個 S3 值物件（class
`kit_status`）：建構時檢查內容； 有
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
方法，所以 `renderUI(st)` 或直接放進
[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)
就會畫成狀態框 （和
[`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status_ui.md)
一樣）。`print(st)` 印出文字版。

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

  `"idle"`、`"success"`、`"warning"`、`"error"` 或 `"stale"`。

- message:

  第一行的結論（一句話，帶數字與單位）：一個字串或 tag。

- warnings:

  需要注意的事（字串向量，或字串與 tag 的 list）。排在最前面。

- notes:

  補充說明（灰色小字）。

- details:

  原始訊息（R 的錯誤原文；收起來）：一個字串或 `NULL`。

- action:

  怎麼辦的按鈕或連結（tag）；`NULL` 不顯示。

- points:

  結果的重點（排在 `warnings` 後面；不會讓狀態變成「請注意」）。

- details_title:

  原始訊息的收合標題（kitsUI 用「kits 的原文」）。

- x:

  `kit_status` 物件。

- ...:

  給
  [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status_ui.md)
  的其他內容（as.tags）；format、print 不用。

## Value

`kit_status` 物件。

## Details

四種狀態各有固定的標籤與顏色：

|             |                    |        |
|-------------|--------------------|--------|
| state       | 標籤               | 底色   |
| `"success"` | 【完成】           | 薄荷綠 |
| `"warning"` | 【完成，但請注意】 | 黃     |
| `"error"`   | 【停下來】         | 鮭紅   |
| `"stale"`   | 【要重新執行】     | 黃     |

`"idle"`（還沒有執行）不顯示。也接受 kitsUI
的名字：`"done"`、`"warn"`、`"stop"`。

## See also

[`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status_ui.md)、[`kit_done_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_done_status.md)、[`kit_error_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_error_status.md)、[`kit_stale_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_stale_status.md)

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
