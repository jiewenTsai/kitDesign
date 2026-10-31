# Problems in a table or list (dark orange-red text)

A list of individual problems inside a step card, such as "還差：…"
("Still needed: …") or "這幾欄有問題" ("these columns have problems").

## Usage

``` r
kit_problems(..., head = NULL, bullets = TRUE)
```

## Arguments

- ...:

  One string (or tag) per problem.

- head:

  Bold text in front, for example "還差：" ("Still needed:"); `NULL`
  shows nothing.

- bullets:

  `TRUE` (default): one bullet per problem; `FALSE`: one per line,
  without bullets (for example when each line is already a full
  sentence, or already has its own numbering).

## Value

`<div class="kit-problems">`; `NULL` when there are no problems.

## Examples

``` r
kit_problems("第 2 列沒有選世代", "第 4 列的波次不是數字", head = "還差：")
#> <div class="kit-problems">
#>   <strong>還差：</strong>
#>   <ul>
#>     <li>第 2 列沒有選世代</li>
#>     <li>第 4 列的波次不是數字</li>
#>   </ul>
#> </div>
kit_problems("bsrs1：w1d5_1 和 w2d5_1 的分數範圍不同", bullets = FALSE)
#> <div class="kit-problems">
#>   <div>bsrs1：w1d5_1 和 w2d5_1 的分數範圍不同</div>
#> </div>
```
