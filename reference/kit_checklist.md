# Checklist

Lists "things to decide" together with "things already fine", placed
before a conversion or run. An S3 value object (class `kit_checklist`, a
list of
[`kit_check()`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)):
put it straight into a page and it renders as
`<ul class="kit-checklist">`, one item per row, with the faintest line
between rows.

## Usage

``` r
kit_checklist(...)

# S3 method for class 'kit_checklist'
as.tags(x, ...)

# S3 method for class 'kit_checklist'
format(x, ...)

# S3 method for class 'kit_checklist'
print(x, ...)
```

## Arguments

- ...:

  [`kit_check()`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  items, or a list of them (`NULL` is skipped).

- x:

  A `kit_checklist` object.

## Value

A `kit_checklist` object.

## Examples

``` r
cl <- kit_checklist(
  kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。",
            actions = kit_button("shift", "全部減 1（建議）")),
  kit_check("ok", "沒有疑似遺漏值代碼"),
  kit_check("note", "有 2 題沒有人作答，不會放進作答檔")
)
# todo: "3 items have scores starting at 1" / "kits needs scores 0, 1, 2…" / button "Subtract 1 from all (recommended)"
# ok:   "No suspected missing-value codes"
# note: "2 items have no responses and will not go into the response file"
cl
#> ! 有 3 題的分數從 1 開始（kits 要的分數是 0、1、2…。）
#> ✓ 沒有疑似遺漏值代碼
#> i 有 2 題沒有人作答，不會放進作答檔
htmltools::as.tags(cl)
#> <ul class="kit-checklist">
#>   <li class="kit-check todo">
#>     <span class="kit-check-mark" aria-hidden="true">!</span>
#>     <span class="visually-hidden">要決定：</span>
#>     <div class="kit-check-text">
#>       <strong>有 3 題的分數從 1 開始</strong>
#>       <span>kits 要的分數是 0、1、2…。</span>
#>       <div class="kit-check-actions">
#>         <button class="btn btn-default action-button btn-sm btn-outline-secondary" id="shift" type="button"><span class="action-label">全部減 1（建議）</span></button>
#>       </div>
#>     </div>
#>   </li>
#>   <li class="kit-check ok">
#>     <span class="kit-check-mark" aria-hidden="true">✓</span>
#>     <span class="visually-hidden">沒問題：</span>
#>     <div class="kit-check-text">
#>       <strong>沒有疑似遺漏值代碼</strong>
#>     </div>
#>   </li>
#>   <li class="kit-check note">
#>     <span class="kit-check-mark" aria-hidden="true">i</span>
#>     <span class="visually-hidden">提醒：</span>
#>     <div class="kit-check-text">
#>       <strong>有 2 題沒有人作答，不會放進作答檔</strong>
#>     </div>
#>   </li>
#> </ul>
```
