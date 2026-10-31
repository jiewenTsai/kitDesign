# 「用 R 怎麼做」的內容：說明＋一個或幾個版本的程式碼（附「複製」）

每個版本是一個
[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)：一行「版本名稱（粗體）＋複製」與下面的程式碼框；
兩個版本時上下排。程式碼每行最多 70
欄（[`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md)）；一律關掉連字。

## Usage

``` r
kit_code_blocks(snips, note = KIT_CODE_NOTE, width = KIT_CODE_WIDTH)
```

## Arguments

- snips:

  程式碼：一個字串、[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  物件，或它們的具名 list／字串向量 （名字是版本名稱）。kitJoin 的
  `list(tidy = , base = )` 會寫成「tidyverse 版」「base R 版」； `NULL`
  的版本略過（例如 `base = NULL` 時只有 tidyverse
  版）。沒有名字時版本名稱是「R」。

- note:

  最上面的一行說明；`NULL` 不顯示。

- width:

  一行最多幾欄；`NULL` 不換行、不檢查。

## Value

[`htmltools::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html)。

## Examples

``` r
kit_code_blocks(list(
  tidy = "joined <- dplyr::left_join(t1, t2, by = \"id\")",
  base = "joined <- merge(t1, t2, by = \"id\", all.x = TRUE)"
))
#> <p class="kit-hint">以下程式碼依你目前的設定產生，是簡化的示範。</p>
#> <div class="kit-code-head">
#>   <strong>tidyverse 版</strong>
#>   <button type="button" class="btn btn-sm btn-outline-secondary kit-copy">複製</button>
#> </div>
#> <pre><code>joined &lt;- dplyr::left_join(t1, t2, by = "id")</code></pre>
#> <div class="kit-code-head">
#>   <strong>base R 版</strong>
#>   <button type="button" class="btn btn-sm btn-outline-secondary kit-copy">複製</button>
#> </div>
#> <pre><code>joined &lt;- merge(t1, t2, by = "id", all.x = TRUE)</code></pre>
kit_code_blocks(c("kits 版" = "fit <- kits::kits_calibrate(resp)"))
#> <p class="kit-hint">以下程式碼依你目前的設定產生，是簡化的示範。</p>
#> <div class="kit-code-head">
#>   <strong>kits 版</strong>
#>   <button type="button" class="btn btn-sm btn-outline-secondary kit-copy">複製</button>
#> </div>
#> <pre><code>fit &lt;- kits::kits_calibrate(resp)</code></pre>
```
