# 維度描述：「5 列 × 7 欄」

維度描述：「5 列 × 7 欄」

## Usage

``` r
kit_dims(nrow, ncol, preview_cols = NULL)
```

## Arguments

- nrow, ncol:

  列數、欄數。

- preview_cols:

  畫面上只預覽前幾欄時給它（比欄數少時補一句「以下只預覽前 N 欄」）。

## Value

字串。

## Examples

``` r
kit_dims(3418, 25)
#> [1] "3,418 列 × 25 欄"
kit_dims(3418, 25, preview_cols = 20)
#> [1] "3,418 列 × 25 欄（以下只預覽前 20 欄）"
```
