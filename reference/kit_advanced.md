# 進階設定：預設收起

設定區裡不常改的選項（文字欄比對、ID 型別轉換、反向題規則、分隔符號…）。
一行小字標題；打開後左邊一條淡線，和其他設定分開（不加框）。

## Usage

``` r
kit_advanced(..., title = "進階設定", open = FALSE, id = NULL)
```

## Arguments

- ...:

  裡面的設定。

- title:

  收合標題（可以是 tag，例如後面接現在的設定）。

- open:

  一開始要不要打開。

- id:

  `<details>` 的 id（給
  [`kit_open_details()`](https://jiewentsai.github.io/kitDesign/reference/kit_open_details.md)
  打開用）。

## Value

`<details class="kit-advanced">`。

## Examples

``` r
kit_advanced(shiny::checkboxInput("trim", "比對前去掉前後空白", TRUE))
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
