# Dimension text: "5 列 × 7 欄" ("5 rows × 7 columns")

Dimension text: "5 列 × 7 欄" ("5 rows × 7 columns")

## Usage

``` r
kit_dims(nrow, ncol, preview_cols = NULL)
```

## Arguments

- nrow, ncol:

  Number of rows and columns.

- preview_cols:

  Give this when the screen previews only the first few columns (if
  fewer than the column count, adds "以下只預覽前 N 欄" ("previewing
  only the first N columns below")).

## Value

A string.

## Examples

``` r
kit_dims(3418, 25)
#> [1] "3,418 列 × 25 欄"
kit_dims(3418, 25, preview_cols = 20)
#> [1] "3,418 列 × 25 欄（以下只預覽前 20 欄）"
```
