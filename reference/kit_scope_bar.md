# Scope bar: an app-wide choice under the tab bar

For a choice that every tab of the app depends on, such as which item
bank is in use. It sits right under the tab bar, without a frame: a
radio group (or a select), one line of small hint text (what is in use
now, how big it is), small buttons on the right, and an optional area
for what must be confirmed after choosing (a checklist and buttons). A
thin line separates it from the page below.

## Usage

``` r
kit_scope_bar(input, line = NULL, actions = NULL, panel = NULL)
```

## Arguments

- input:

  The input: usually `shiny::radioButtons(..., inline = TRUE)` (2–5
  choices) or
  [`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html).

- line:

  Tags or text for the hint line, for example
  `"目前：TDCYP 題庫 · 412 題"`. `NULL` for none. Put dynamic parts in
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) /
  `shiny::textOutput(inline = TRUE)`.

- actions:

  Small buttons on the right of the hint line
  ([`kit_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_button.md)
  with the default kind,
  [`kit_download_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_download_button.md),
  [`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)).
  A list or a single tag; `NULL` for none.

- panel:

  Optional area under the line for what must be confirmed after choosing
  (for example a
  [`kit_checklist()`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  and buttons, or a
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)).
  `NULL` for none.

## Value

`<div class="kit-scopebar">`.

## Details

Markup: `div.kit-scopebar` \> the input, `div.kit-scopebar-line`
(`line`, then `div.kit-scopebar-actions` with `actions`),
`div.kit-scopebar-panel` (`panel`). Use `span.kit-scopebar-todo` in
`line` for something still to do ("還沒選題庫").

## Examples

``` r
kit_scope_bar(
  shiny::radioButtons("bank", "題庫", c("TDCYP" = "tdcyp", "上傳自己的" = "own"),
                      inline = TRUE),
  line = "目前：TDCYP 題庫 · 412 題",
  actions = list(kit_button("bank_dl", "下載題庫"), kit_button("bank_new", "新增題庫"))
)
#> <div class="kit-scopebar">
#>   <div id="bank" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="bank-label">
#>     <label class="control-label" id="bank-label" for="bank">題庫</label>
#>     <div class="shiny-options-group">
#>       <label class="radio-inline">
#>         <input type="radio" name="bank" value="tdcyp" checked="checked"/>
#>         <span>TDCYP</span>
#>       </label>
#>       <label class="radio-inline">
#>         <input type="radio" name="bank" value="own"/>
#>         <span>上傳自己的</span>
#>       </label>
#>     </div>
#>   </div>
#>   <div class="kit-scopebar-line">
#>     目前：TDCYP 題庫 · 412 題
#>     <div class="kit-scopebar-actions">
#>       <button class="btn btn-default action-button btn-sm btn-outline-secondary" id="bank_dl" type="button"><span class="action-label">下載題庫</span></button>
#>       <button class="btn btn-default action-button btn-sm btn-outline-secondary" id="bank_new" type="button"><span class="action-label">新增題庫</span></button>
#>     </div>
#>   </div>
#> </div>
```
