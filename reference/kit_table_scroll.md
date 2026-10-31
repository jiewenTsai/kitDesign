# Put wide tables in here: they scroll sideways in their own box and do not break the layout

Put wide tables in here: they scroll sideways in their own box and do
not break the layout.

## Usage

``` r
kit_table_scroll(..., tall = FALSE)
```

## Arguments

- ...:

  Tables (for example
  [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md)
  or
  [`shiny::tableOutput()`](https://rdrr.io/pkg/shiny/man/renderTable.html)).

- tall:

  For long tables: fixed height (about 26rem), with the header fixed at
  the top.

## Value

`<div class="kit-table-scroll">`.

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
