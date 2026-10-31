# 檢查清單（Checklist）

把「要決定的事」和「已經沒問題的事」列在一起，放在轉換或執行之前。 一個
S3 值物件（class
`kit_checklist`，[`kit_check()`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
的 list）：直接放進頁面就畫成
`<ul class="kit-checklist">`，一列一件事，列之間一條最淡的線。

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

  [`kit_check()`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)，或它們的
  list（`NULL` 略過）。

- x:

  `kit_checklist` 物件。

## Value

`kit_checklist` 物件。

## Examples

``` r
cl <- kit_checklist(
  kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。",
            actions = kit_button("shift", "全部減 1（建議）")),
  kit_check("ok", "沒有疑似遺漏值代碼"),
  kit_check("note", "有 2 題沒有人作答，不會放進作答檔")
)
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
