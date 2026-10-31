# Small table (put directly inside renderUI(); no separate output needed)

White background, black header with white text, zebra stripes, width
fits the content. Integer columns get thousands separators automatically
(3389 → 3,389). Put an `h4` title and a
[`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/reference/kit_rows_note.md)
line above it.

## Usage

``` r
kit_static_table(df, class = "table table-sm table-striped")
```

## Arguments

- df:

  A data.frame.

- class:

  The table's class.

## Value

`<table class="table table-sm table-striped">`.

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
