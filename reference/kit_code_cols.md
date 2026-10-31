# Display width of each line (CJK and full-width characters count as 2 columns)

KIT code examples and notes are at most about 70 columns per line: Latin
letters, digits, and symbols count as 1 column, Chinese characters (and
other full-width characters) count as 2.

## Usage

``` r
kit_code_cols(x)
```

## Arguments

- x:

  A character vector (one element per line).

## Value

An integer vector: the number of columns in each line.

## See also

[`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md)

## Examples

``` r
kit_code_cols(c("abc", "讀 CSV", ""))
#> [1] 3 6 0
# Which lines are wider than 70 columns
lines <- c("x <- 1", strrep("中", 36))
which(kit_code_cols(lines) > 70)
#> [1] 2
```
