# 每行的顯示寬度（中日韓字、全形字算 2 欄）

KIT 的程式碼範例與說明一行最多約 70 欄：英文字母、數字、符號算 1 欄，
中文字（與其他全形字）算 2 欄。

## Usage

``` r
kit_code_cols(x)
```

## Arguments

- x:

  字串向量（一個元素一行）。

## Value

整數向量：每一行幾欄。

## See also

[`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md)

## Examples

``` r
kit_code_cols(c("abc", "讀 CSV", ""))
#> [1] 3 6 0
# 哪幾行超過 70 欄
lines <- c("x <- 1", strrep("中", 36))
which(kit_code_cols(lines) > 70)
#> [1] 2
```
