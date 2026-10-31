# "還差" ("Still needed"): the sentence shown when there are not enough files

"還差" ("Still needed"): the sentence shown when there are not enough
files.

## Usage

``` r
kit_need_files(n_files, need = 2L)
```

## Arguments

- n_files:

  How many files have been added.

- need:

  The minimum number of files this page needs.

## Value

One sentence; `NULL` when there are enough files.

## Examples

``` r
kit_need_files(1L, need = 2L)
#> [1] "至少要 2 個波次的檔案，目前只有 1 個"
kit_need_files(0L, need = 1L)
#> [1] "先加入檔案"
```
