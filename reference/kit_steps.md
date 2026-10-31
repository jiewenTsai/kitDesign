# Numbered list of steps (for the `steps` of [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md))

Note: this is the `<ol>` inside the guide box, not a step card; step
cards are
[`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md).

## Usage

``` r
kit_steps(...)
```

## Arguments

- ...:

  One string (or character vector) per step.

## Value

`<ol class="kit-steps">`.

## Examples

``` r
kit_steps("選檔案", "選 ID 欄", "按「執行串接」")
#> <ol class="kit-steps">
#>   <li>選檔案</li>
#>   <li>選 ID 欄</li>
#>   <li>按「執行串接」</li>
#> </ol>
```
