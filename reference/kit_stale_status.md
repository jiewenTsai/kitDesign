# Old result no longer valid after files or settings change (【要重新執行】, "Run again")

Old result no longer valid after files or settings change
(【要重新執行】, "Run again").

## Usage

``` r
kit_stale_status(run_label, message = NULL)
```

## Arguments

- run_label:

  The primary button's text, for example "執行串接" ("Run join").

- message:

  Your own sentence (the default is
  "檔案或設定改過了，舊的結果已清除：請再按一次「…」。", "Files or
  settings changed and the old result was cleared: press '…' again.").

## Value

A `kit_status` object.

## Examples

``` r
kit_stale_status("執行串接")$message
#> [1] "檔案或設定改過了，舊的結果已清除：請再按一次「執行串接」。"
```
