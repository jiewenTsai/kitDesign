# Advanced settings: collapsed by default

Options in a settings area that are rarely changed (text column
matching, ID type conversion, reverse-scored item rules, separators…). A
one-line small-print title; when opened, a faint line on the left sets
it apart from the other settings (no box).

## Usage

``` r
kit_advanced(..., title = "進階設定", open = FALSE, id = NULL)
```

## Arguments

- ...:

  The settings inside.

- title:

  The collapsible title (can be a tag, e.g. followed by the current
  settings).

- open:

  Whether it starts open.

- id:

  The id of the `<details>` (used by
  [`kit_open_details()`](https://jiewentsai.github.io/kitDesign/reference/kit_open_details.md)
  to open it).

## Value

`<details class="kit-advanced">`.

## Examples

``` r
kit_advanced(shiny::checkboxInput("trim", "比對前去掉前後空白", TRUE))  # "Trim spaces before matching"
#> <details class="kit-advanced">
#>   <summary>進階設定</summary>
#>   <div class="kit-advanced-body">
#>     <div class="form-group shiny-input-container">
#>       <div class="checkbox">
#>         <label>
#>           <input id="trim" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>           <span>比對前去掉前後空白</span>
#>         </label>
#>       </div>
#>     </div>
#>   </div>
#> </details>
```
