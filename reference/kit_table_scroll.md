# 寬的表放在這裡面：在自己的框裡左右捲，不撐破版面

寬的表放在這裡面：在自己的框裡左右捲，不撐破版面

## Usage

``` r
kit_table_scroll(..., tall = FALSE)
```

## Arguments

- ...:

  表格（例如
  [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md)
  或
  [`shiny::tableOutput()`](https://rdrr.io/pkg/shiny/man/renderTable.html)）。

- tall:

  長表時固定高度（約 26rem）、表頭固定在上面。

## Value

`<div class="kit-table-scroll">`。

## Examples

``` r
kit_table_scroll(kit_static_table(data.frame(id = 1:3)))
#> <div class="kit-table-scroll">
#>   <table class="table table-sm table-striped">
#>     <thead>
#>       <tr>
#>         <th>id</th>
#>       </tr>
#>     </thead>
#>     <tbody>
#>       <tr>
#>         <td>1</td>
#>       </tr>
#>       <tr>
#>         <td>2</td>
#>       </tr>
#>       <tr>
#>         <td>3</td>
#>       </tr>
#>     </tbody>
#>   </table>
#> </div>
```
