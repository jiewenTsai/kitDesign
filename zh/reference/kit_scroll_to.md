# 執行完把狀態框捲到畫面上方

「先結果、後細節」：在主要按鈕的
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)
最後呼叫 `kit_scroll_to("status")`。 等這一輪的 output
都送到瀏覽器以後（`session$onFlushed()`）才捲，狀態框已經畫好了。
使用者設定「減少動態效果」時直接跳過去，不平滑捲動。

## Usage

``` r
kit_scroll_to(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  模組裡的 output id（會自動加上模組的 namespace），例如 `"status"`。

- session:

  預設是目前的 session（模組裡呼叫就是模組的 session）。

## Value

不可見的完整 id；沒有 session 時是 `NULL`。

## Examples

``` r
if (interactive()) {
  shiny::observeEvent(input$run, {
    # …執行…
    kit_scroll_to("status")
  })
}
```
