# Content of "How to do it in R": a note plus code in one or more versions (with "Copy")

Each version is a
[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md):
a line with "version name (bold) + Copy" and the code box below it; two
versions are stacked vertically. Code lines are at most 70 columns
([`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md));
ligatures are always turned off.

## Usage

``` r
kit_code_blocks(snips, note = KIT_CODE_NOTE, width = KIT_CODE_WIDTH)
```

## Arguments

- snips:

  The code: a string, a
  [`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  object, or a named list / character vector of them (names are version
  names). kitJoin's `list(tidy = , base = )` is labeled "tidyverse 版"
  ("tidyverse version") and "base R 版" ("base R version"); `NULL`
  versions are skipped (e.g. with `base = NULL` there is only the
  tidyverse version). Without names the version name is "R".

- note:

  A one-line note at the top; `NULL` shows nothing.

- width:

  Maximum columns per line; `NULL` means no wrapping and no check.

## Value

[`htmltools::tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

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
