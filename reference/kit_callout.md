# Callout

A reminder the user should know before pressing a button. It is not a
result, so it has no shadow. At most one per section; if it can go in
the status box, don't add a separate callout; if there is a button, put
the button outside the box.

## Usage

``` r
kit_callout(..., warn = FALSE, class = NULL)
```

## Arguments

- ...:

  The content of the box.

- warn:

  `FALSE`: sky-blue info; `TRUE`: yellow caution.

- class:

  An extra class.

## Value

`<div class="kit-callout">` (plus `kit-callout-warn` for caution).

## Examples

``` r
kit_callout("外部連結不適用：這一回合只有一個世代，這不是錯誤。")
#> <div class="kit-callout">外部連結不適用：這一回合只有一個世代，這不是錯誤。</div>
# "External linking does not apply: this round has only one cohort. This is not an error."
kit_callout("資料裡有疑似遺漏值代碼，建議先到「遺漏值處理」。", warn = TRUE)
#> <div class="kit-callout kit-callout-warn">資料裡有疑似遺漏值代碼，建議先到「遺漏值處理」。</div>
# "The data seem to contain missing-value codes; go to 'Missing values' first."
```
