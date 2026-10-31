# Page guide: what this page does

A one-line guide at the top of each tab, collapsed by default: only the
sentence "這一頁做什麼：" ("What this page does:") is visible, with
"看步驟 ▸" ("See steps ▸") next to it; opening it shows the steps, what
you get, additional notes, and technical notes. No border, small gray
text, a light line below.

## Usage

``` r
kit_tab_guide(
  goal,
  steps,
  output,
  technical = NULL,
  note = NULL,
  diagram = NULL
)
```

## Arguments

- goal:

  One sentence, no more than 30 characters.

- steps:

  The steps to follow:
  [`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md)
  (3–6 points), or a character vector (turned into
  [`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md)
  automatically).

- output:

  What you get.

- technical:

  Technical notes (for people who want to know how it works; collapsed
  one more level); `NULL` shows nothing.

- note:

  Additional notes (small gray text); `NULL` shows nothing.

- diagram:

  A diagram
  ([`kit_diagram()`](https://jiewentsai.github.io/kitDesign/reference/kit_diagram.md)):
  placed outside the guide box, right after it, and visible even when
  the guide is collapsed; `NULL` shows nothing.

## Value

Without a diagram, `<details class="kit-guide kit-guide-page">`; with a
diagram, it is wrapped in `<div class="kit-guide kit-guide-wrap">`.

## See also

[`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md),
[`kit_diagram()`](https://jiewentsai.github.io/kitDesign/reference/kit_diagram.md)

## Examples

``` r
kit_tab_guide(
  goal = "把多個波次的檔案依 ID 接成一張寬資料。",
  steps = kit_steps("選要串接的檔案", "選 ID 欄", "按「執行串接」"),
  output = "一張寬資料，可以下載 CSV、SAV。"
)
#> <details class="kit-guide kit-guide-page">
#>   <summary>
#>     <strong>這一頁做什麼：</strong>
#>     把多個波次的檔案依 ID 接成一張寬資料。
#>     <span class="kit-guide-more"></span>
#>   </summary>
#>   <div class="kit-guide-body">
#>     <div>
#>       <strong>步驟：</strong>
#>       <ol class="kit-steps">
#>         <li>選要串接的檔案</li>
#>         <li>選 ID 欄</li>
#>         <li>按「執行串接」</li>
#>       </ol>
#>     </div>
#>     <p>
#>       <strong>會得到：</strong>
#>       一張寬資料，可以下載 CSV、SAV。
#>     </p>
#>   </div>
#> </details>
```
