# 長表的說明：「共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。」

放在表上面的一行 `kit-hint` 小字。

## Usage

``` r
kit_rows_note(nrow, ncol = NULL, shown_rows, shown_cols = NULL)
```

## Arguments

- nrow, ncol:

  全部的列數、欄數（`ncol = NULL` 時不提欄）。

- shown_rows, shown_cols:

  畫面上顯示幾列、幾欄（`shown_cols = NULL` 時不提欄）。

## Value

字串。

## Examples

``` r
kit_rows_note(157, shown_rows = 20)
#> [1] "共 157 列，以下前 20 列。"
kit_rows_note(3418, 25, shown_rows = 10, shown_cols = 20)
#> [1] "共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。"
kit_rows_note(8, shown_rows = 10)
#> [1] "共 8 列，以下是全部。"
```
