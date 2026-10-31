# 把一段程式碼換行成每行最多 70 欄

「用 R
怎麼做」顯示之前才換行（[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
會自動做），產生程式碼的函式不用管寬度：

## Usage

``` r
kit_code_wrap(code, width = KIT_CODE_WIDTH)
```

## Arguments

- code:

  程式碼（字串；可以有好幾行，或好幾個字串）。

- width:

  一行最多幾欄。

## Value

一個字串（`code` 長度 0 時原樣傳回）。

## Details

- 註解：在空白或中文字之間換行，續行一樣以「# 」開頭；標點不放在行首。

- 程式：在括號裡的逗號後面換行，續行對齊那個括號後面（R
  在括號裡換行一定合法）。 括號在前面幾行打開的（例如 `mutate(`
  自己一行，參數在下一行），續行和這一行一樣縮排。

- 行尾註解讓這一行太寬時，搬到這一行上面。

換行後再 parse 一次：和原本的運算式不同（或原本就 parse
不了）時，維持原樣。
斷不開的地方（例如很長的字串）也維持原樣，在程式碼框裡左右捲。

## See also

[`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_cols.md)、[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)

## Examples

``` r
code <- paste0(
  "x <- c(\"M03\", \"M03\", \"M03\", \"M36\", \"M36\", \"M36\", ",
  "\"M48\", \"M48\", \"M60\", \"M60\")"
)
cat(kit_code_wrap(code))
#> x <- c("M03", "M03", "M03", "M36", "M36", "M36", "M48", "M48", "M60",
#>        "M60")
```
