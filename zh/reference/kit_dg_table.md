# 圖解用的小表格（2–3 欄、2–4 列）

配角：不加框、表格跟著內容寬、1px
細線、淡色表頭（不是大資料表的黑表頭）；
值用等寬字。新加的欄淡萊姆底，欄名後面加「（新）」，不只靠顏色；
空的格子寫灰色的「（空）」。

## Usage

``` r
kit_dg_table(df, title, added = NULL, row_header = FALSE)
```

## Arguments

- df:

  data.frame（值會轉成文字）；`NA` 或 `""` 顯示成「（空）」。

- title:

  表名，放在 `<caption>`（例如「第 1 波（t1）」「結果」）。

- added:

  這一步新加的欄名（例如 `wave`）。

- row_header:

  第 1 欄是列標題（`<th scope="row">`）。

## Value

`<table class="kit-dg-table">`。

## Examples

``` r
kit_dg_table(data.frame(id = 1:2, score = c(3, NA)), "第 1 波（t1）")
#> <table class="kit-dg-table">
#>   <caption>第 1 波（t1）</caption>
#>   <thead>
#>     <tr>
#>       <th scope="col">id</th>
#>       <th scope="col">score</th>
#>     </tr>
#>   </thead>
#>   <tbody>
#>     <tr>
#>       <td>1</td>
#>       <td>3</td>
#>     </tr>
#>     <tr>
#>       <td>2</td>
#>       <td>
#>         <span class="kit-dg-empty">（空）</span>
#>       </td>
#>     </tr>
#>   </tbody>
#> </table>
```
