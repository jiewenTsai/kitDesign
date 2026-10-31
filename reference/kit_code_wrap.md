# Wrap code to at most 70 columns per line

"How to do it in R" wraps the code only right before showing it
([`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
does this automatically), so functions that generate code need not worry
about width:

## Usage

``` r
kit_code_wrap(code, width = KIT_CODE_WIDTH)
```

## Arguments

- code:

  The code (a string; may have several lines, or be several strings).

- width:

  Maximum columns per line.

## Value

A single string (returned as is when `code` has length 0).

## Details

- Comments: break at spaces or between Chinese characters; continuation
  lines also start with "# "; punctuation is not put at the start of a
  line.

- Code: break after a comma inside parentheses, and align continuation
  lines just after that parenthesis (a line break inside parentheses is
  always valid R). If the parenthesis was opened on an earlier line
  (e.g. `mutate(` on its own line with the arguments on the next),
  continuation lines use the same indent as this line.

- If a trailing comment makes the line too wide, it is moved above the
  line.

After wrapping, the code is parsed again: if the expression differs from
the original (or the original did not parse), the code is left
unchanged. Places that cannot be broken (e.g. a very long string) are
also left as is and scroll sideways in the code box.

## See also

[`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_cols.md),
[`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)

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
