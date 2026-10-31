# Integer with thousands separators

KIT design language: numbers with four or more digits get thousands
separators, as in "3,389 人" ("3,389 people"). Decimals are rounded to
integers.

## Usage

``` r
kit_num(x)
```

## Arguments

- x:

  A number (or a string that can be converted to a number).

## Value

A string, for example `"3,418"`.

## Examples

``` r
kit_num(3418)
#> [1] "3,418"
kit_num(c(5, 12345, 1e6))
#> [1] "5"         "12,345"    "1,000,000"
```
