# Small table for diagrams (2–3 columns, 2–4 rows)

A supporting element: no box, table as wide as its content, 1px thin
lines, a light header (not the black header of large data tables);
values in a monospace font. New columns get a light lime background and
"（新）" ("(new)") after the name, so it does not rely on color alone;
empty cells show a gray "（空）" ("(empty)").

## Usage

``` r
kit_dg_table(df, title, added = NULL, row_header = FALSE)
```

## Arguments

- df:

  A data.frame (values are converted to text); `NA` or `""` shows as
  "（空）" ("(empty)").

- title:

  The table name, placed in `<caption>` (e.g. "第 1 波（t1）" ("Wave 1
  (t1)"), "結果" ("Result")).

- added:

  Names of columns added in this step (e.g. `wave`).

- row_header:

  Whether column 1 holds row headers (`<th scope="row">`).

## Value

`<table class="kit-dg-table">`.

## Examples

``` r
kit_dg_table(data.frame(id = 1:2, score = c(3, NA)), "第 1 波（t1）")  # "Wave 1 (t1)"
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
