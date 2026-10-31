# 一個版本的程式碼（CodePanel）

一個 S3 值物件（class `kit_code`）：程式碼文字＋版本名稱。有
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
方法：
直接放進頁面就畫成「版本名稱（粗體）＋複製」一行和下面的程式碼框，
程式碼先用
[`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_wrap.md)
換行成每行最多 70 欄（中文字算 2 欄）。
換行後還是有太長的行（例如斷不開的長字串）時發出
warning（不會停下來），在框裡左右捲。

## Usage

``` r
kit_code(code, label = "R", width = KIT_CODE_WIDTH)

# S3 method for class 'kit_code'
as.tags(x, ...)

# S3 method for class 'kit_code'
format(x, ...)

# S3 method for class 'kit_code'
print(x, ...)
```

## Arguments

- code:

  程式碼（字串向量；一個元素一行，或含換行）。

- label:

  版本名稱，例如「tidyverse 版」「base R 版」「kits 版」。

- width:

  一行最多幾欄；`NULL` 不換行、不檢查。

- x:

  `kit_code` 物件。

- ...:

  不用。

## Value

`kit_code` 物件。

## See also

[`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_blocks.md)、[`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_code_panel_ui.md)

## Examples

``` r
x <- kit_code("joined <- dplyr::left_join(t1, t2, by = \"id\")", "tidyverse 版")
x
#> ## tidyverse 版
#> joined <- dplyr::left_join(t1, t2, by = "id")
htmltools::as.tags(x)
#> <div class="kit-code-head">
#>   <strong>tidyverse 版</strong>
#>   <button type="button" class="btn btn-sm btn-outline-secondary kit-copy">複製</button>
#> </div>
#> <pre><code>joined &lt;- dplyr::left_join(t1, t2, by = "id")</code></pre>
```
