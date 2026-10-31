# 「還差」：檔案不夠時的那一句

「還差」：檔案不夠時的那一句

## Usage

``` r
kit_need_files(n_files, need = 2L)
```

## Arguments

- n_files:

  已經加入幾個檔案。

- need:

  這一頁至少要幾個檔案。

## Value

一句話；檔案夠了時是 `NULL`。

## Examples

``` r
kit_need_files(1L, need = 2L)
#> [1] "至少要 2 個波次的檔案，目前只有 1 個"
kit_need_files(0L, need = 1L)
#> [1] "先加入檔案"
```
