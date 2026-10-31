# 小表格（直接放在 renderUI() 裡，不用另開 output）

白底、黑表頭白字、斑馬紋、寬度跟著內容。整數欄自動加千分位（3389 →
3,389）。 上面放一個 `h4` 標題與一行
[`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/reference/kit_rows_note.md)。

## Usage

``` r
kit_static_table(df, class = "table table-sm table-striped")
```

## Arguments

- df:

  data.frame。

- class:

  表格的 class。

## Value

`<table class="table table-sm table-striped">`。

## Examples

``` r
kit_static_table(data.frame(世代 = c("M03", "M36"), 人數 = c(3389, 1250)))
#> <table class="table table-sm table-striped">
#>   <thead>
#>     <tr>
#>       <th>世代</th>
#>       <th>人數</th>
#>     </tr>
#>   </thead>
#>   <tbody>
#>     <tr>
#>       <td>M03</td>
#>       <td>3,389</td>
#>     </tr>
#>     <tr>
#>       <td>M36</td>
#>       <td>1,250</td>
#>     </tr>
#>   </tbody>
#> </table>
```
