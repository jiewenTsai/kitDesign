# 離開頁面前的提醒

有這一回合的結果時（例如校準過），關掉或重新整理分頁前，瀏覽器會先問一次。
在 server
裡依結果開關：`shiny::observe(kit_unload_guard(!is.null(result())))`。

## Usage

``` r
kit_unload_guard(on = TRUE, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- on:

  `TRUE` 開、`FALSE` 關。

- session:

  預設是目前的 session。

## Value

不可見的 `on`。

## Examples

``` r
if (interactive()) kit_unload_guard(TRUE)
```
