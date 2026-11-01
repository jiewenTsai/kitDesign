# 範圍選擇列：分頁列下面、全 app 共用的選擇

給每一個分頁都照著做的選擇，例如用哪一份題庫。放在分頁列正下方、不加框：一組單選圓鈕（或下拉選單）、
一行 hint
小字（現在用的是哪一份、多大）、右邊的小按鈕，以及選了以後要確認的內容（檢查清單和按鈕）。
下面一條淡線和頁面分開。

## Usage

``` r
kit_scope_bar(input, line = NULL, actions = NULL, panel = NULL)
```

## Arguments

- input:

  輸入元件：通常是 `shiny::radioButtons(..., inline = TRUE)`（2–5
  個選項）或
  [`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)。

- line:

  一行 hint 的內容，例如 `"目前：TDCYP 題庫 · 412 題"`。`NULL`
  是不放。會變的部分用
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)／`shiny::textOutput(inline = TRUE)`。

- actions:

  hint 右邊的小按鈕（預設樣子的
  [`kit_button()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_button.md)、[`kit_download_button()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_download_button.md)、
  [`shiny::fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)）。list
  或單一個 tag；`NULL` 是不放。

- panel:

  選了以後要確認的內容，放在 hint 下面（例如
  [`kit_checklist()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_checklist.md)
  和按鈕，或一個
  [`shiny::uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)）。`NULL`
  是不放。

## Value

`<div class="kit-scopebar">`。

## Details

標記：`div.kit-scopebar` \>
輸入元件、`div.kit-scopebar-line`（`line`，接著
`div.kit-scopebar-actions` 放
`actions`）、`div.kit-scopebar-panel`（`panel`）。 還沒做的事在 `line`
裡用 `span.kit-scopebar-todo`（「還沒選題庫」）。

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
