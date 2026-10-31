# 顯示通知（Shiny 的 showNotification）

【停下來】用紅色、顯示 10 秒；其他用一般樣式、顯示 6 秒。

## Usage

``` r
kit_notify(st, session = shiny::getDefaultReactiveDomain(), duration = NULL)
```

## Arguments

- st:

  [`kit_status()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_status.md)
  物件，或一個字串（一般通知）。

- session:

  Shiny session（預設是目前的 session）。

- duration:

  顯示幾秒；`NULL` 時照上面的預設。

## Value

通知的 id（不可見）；`"idle"` 或沒有 session 時是 `NULL`。

## Examples

``` r
if (interactive()) {
  kit_notify(kit_done_status("串接完成。"))
}
```
