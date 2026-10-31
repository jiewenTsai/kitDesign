# 檔案或設定變更後，舊結果失效（【要重新執行】）

檔案或設定變更後，舊結果失效（【要重新執行】）

## Usage

``` r
kit_stale_status(run_label, message = NULL)
```

## Arguments

- run_label:

  主要按鈕的字，例如「執行串接」。

- message:

  自己寫的一句話（預設是「檔案或設定改過了，舊的結果已清除：請再按一次「…」。」）。

## Value

`kit_status` 物件。

## Examples

``` r
kit_stale_status("執行串接")$message
#> [1] "檔案或設定改過了，舊的結果已清除：請再按一次「執行串接」。"
```
