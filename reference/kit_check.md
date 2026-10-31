# One checklist row

An S3 value object (class `kit_check`): its content is checked when it
is built; it has an
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
method, so putting it straight into a page renders
`<li class="kit-check">`. Usually placed inside
[`kit_checklist()`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md).

## Usage

``` r
kit_check(state = c("todo", "ok", "note"), title, why = "", actions = NULL)

# S3 method for class 'kit_check'
as.tags(x, ...)

# S3 method for class 'kit_check'
format(x, ...)

# S3 method for class 'kit_check'
print(x, ...)
```

## Arguments

- state:

  `"todo"`, `"ok"`, or `"note"`.

- title:

  One sentence (a string).

- why:

  The small print below (why); `""` or length 0 shows nothing.
  (kitJoin's `kitsdata_check()` calls it `text`.)

- actions:

  Buttons for the decision (a tag or list of tags); placed below the
  explanation.

- x:

  A `kit_check` object.

- ...:

  Not used.

## Value

A `kit_check` object.

## Details

A mark on the left, preceded by hidden text (read by screen readers):

- `"todo"`: **!** needs a decision ("要決定：", "To decide:"). One bold
  sentence, a line of small print below saying why, and the decision
  buttons below that.

- `"ok"`: **✓** fine, or already decided ("沒問題：", "OK:"). Font
  weight 500.

- `"note"`: **i** a reminder, no decision needed ("提醒：", "Note:").

Put the recommended option first and write "（建議）" ("(recommended)")
on its button.

## Examples

``` r
kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。")
#> ! 有 3 題的分數從 1 開始（kits 要的分數是 0、1、2…。）
# "3 items have scores starting at 1" / "kits needs scores 0, 1, 2…"
htmltools::as.tags(kit_check("ok", "45 題的分數都是整數"))  # "All 45 items have integer scores"
#> <li class="kit-check ok">
#>   <span class="kit-check-mark" aria-hidden="true">✓</span>
#>   <span class="visually-hidden">沒問題：</span>
#>   <div class="kit-check-text">
#>     <strong>45 題的分數都是整數</strong>
#>   </div>
#> </li>
```
