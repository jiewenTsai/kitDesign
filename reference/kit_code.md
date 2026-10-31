# Code for one version (code panel)

An S3 value object (class `kit_code`): code text plus a version name. It
has an
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
method: put it straight into a page and it renders a line with "version
name (bold) + Copy" and the code box below, with the code first wrapped
by
[`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md)
to at most 70 columns per line (Chinese characters count as 2). If a
line is still too long after wrapping (e.g. a long string that cannot be
broken), it gives a warning (it does not stop), and the box scrolls
sideways.

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

  The code (a character vector; one element per line, or containing
  newlines).

- label:

  The version name, e.g. "tidyverse 版" ("tidyverse version"), "base R
  版" ("base R version"), "kits 版" ("kits version").

- width:

  Maximum columns per line; `NULL` means no wrapping and no check.

- x:

  A `kit_code` object.

- ...:

  Not used.

## Value

A `kit_code` object.

## See also

[`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md),
[`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)

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
