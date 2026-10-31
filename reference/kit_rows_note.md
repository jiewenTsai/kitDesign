# Note for a long table: "共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。" ("3,418 rows × 25 columns in total; first 10 rows and 20 columns below.")

One line of small `kit-hint` text placed above the table.

## Usage

``` r
kit_rows_note(nrow, ncol = NULL, shown_rows, shown_cols = NULL)
```

## Arguments

- nrow, ncol:

  Total number of rows and columns (with `ncol = NULL`, columns are not
  mentioned).

- shown_rows, shown_cols:

  How many rows and columns are shown on screen (with
  `shown_cols = NULL`, columns are not mentioned).

## Value

A string.

## Examples

``` r
kit_rows_note(157, shown_rows = 20)
#> [1] "共 157 列，以下前 20 列。"
kit_rows_note(3418, 25, shown_rows = 10, shown_cols = 20)
#> [1] "共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。"
kit_rows_note(8, shown_rows = 10)
#> [1] "共 8 列，以下是全部。"
```
