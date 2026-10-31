# An error meant for the user

The message should be plain-language Chinese that says what went wrong
and how to fix it;
[`kit_error_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_error_status.md)
shows it as written in the status box, with no technical details. Any
other, unexpected error is wrapped as "…時發生沒有預期到的問題" ("an
unexpected problem occurred while …"), with the original message tucked
away.

## Usage

``` r
kit_abort(..., class = NULL, data = list())
```

## Arguments

- ...:

  The message (joined with
  [`paste0()`](https://rdrr.io/r/base/paste.html)).

- class:

  An extra condition class (the caller can handle it separately, e.g. to
  show a confirmation dialog).

- data:

  Other fields to attach to the condition (a named list).

## Value

Does not return: throws a `kit_user_error` error.

## Examples

``` r
e <- tryCatch(kit_abort("至少要 ", 2, " 個波次的檔案。"), error = identity)  # "Need files from at least 2 waves."
class(e)
#> [1] "kit_user_error" "error"          "condition"     
conditionMessage(e)
#> [1] "至少要 2 個波次的檔案。"
```
