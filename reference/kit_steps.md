# 編號的步驟清單（放在 [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md) 的 `steps`）

注意：這是說明框裡的 `<ol>`，不是步驟卡；步驟卡是
[`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md)。

## Usage

``` r
kit_steps(...)
```

## Arguments

- ...:

  每一步一個字串（或字串向量）。

## Value

`<ol class="kit-steps">`。

## Examples

``` r
kit_steps("選檔案", "選 ID 欄", "按「執行串接」")
#> <ol class="kit-steps">
#>   <li>選檔案</li>
#>   <li>選 ID 欄</li>
#>   <li>按「執行串接」</li>
#> </ol>
```
