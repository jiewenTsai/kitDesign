# 頁面說明：這一頁做什麼（PageGuide）

每個分頁最上面的一行說明，預設收起：只看到「這一頁做什麼：」一句，旁邊「看步驟
▸」；
打開才看到步驟、會得到什麼、補充與技術說明。沒有框、小字、灰色，下面一條淡線。

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

  一句話，不超過 30 字。

- steps:

  操作步驟：[`kit_steps()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_steps.md)（3–6
  點），或一個字串向量（自動變成
  [`kit_steps()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_steps.md)）。

- output:

  會得到什麼。

- technical:

  技術說明（給想了解原理的人，再收一層）；`NULL` 不顯示。

- note:

  補充（灰色小字）；`NULL` 不顯示。

- diagram:

  圖解（[`kit_diagram()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_diagram.md)）：放在說明框外面、緊接在後面，收起時也看得到；
  `NULL` 不顯示。

## Value

沒有圖解時是
`<details class="kit-guide kit-guide-page">`；有圖解時外面再包一層
`<div class="kit-guide kit-guide-wrap">`。

## See also

[`kit_steps()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_steps.md)、[`kit_diagram()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_diagram.md)

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
