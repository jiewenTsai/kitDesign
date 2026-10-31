# Was the error thrown by [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)?

Was the error thrown by
[`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)?

## Usage

``` r
kit_is_user_error(e)
```

## Arguments

- e:

  The error (a condition).

## Value

`TRUE` or `FALSE`.

## Examples

``` r
kit_is_user_error(tryCatch(kit_abort("x"), error = identity))
#> [1] TRUE
```
