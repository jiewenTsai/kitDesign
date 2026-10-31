# 是不是 [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md) 丟出的錯誤

是不是
[`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
丟出的錯誤

## Usage

``` r
kit_is_user_error(e)
```

## Arguments

- e:

  錯誤（condition）。

## Value

`TRUE` 或 `FALSE`。

## Examples

``` r
kit_is_user_error(tryCatch(kit_abort("x"), error = identity))
#> [1] TRUE
```
