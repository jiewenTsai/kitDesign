# 按鈕（Button）

一個
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)，class
照按鈕的種類：

## Usage

``` r
kit_button(id, label, kind = "secondary", ..., class = NULL)
```

## Arguments

- id:

  按鈕的 input id。

- label:

  按鈕上的字。

- kind:

  `"primary"`、`"secondary"` 或 `"danger"`。

- ...:

  其他傳給
  [`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
  的參數（例如 `disabled = TRUE`、`icon`）。

- class:

  另外加的 class。

## Value

`<button class="btn ...">`。

## Details

- `"primary"`：主要按鈕，萊姆底、大字、卡片陰影。一頁一個，加上最下面的「下一步」。

- `"secondary"`：小按鈕，白底、細框、沒有陰影。用在下載、全選、範例檔、上移下移、複製。

- `"danger"`：危險按鈕，鮭紅底。用在刪除、移除、這一回合不做。

一般按鈕（白底、黑框、小陰影，例如「對，下一步」）直接用
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)。
文字用動詞開頭，說清楚按下去會發生什麼；會離開這一頁的，文字後面加「→」。

## Examples

``` r
kit_button("run", "執行串接", "primary")
#> <button class="btn btn-default action-button btn-primary" id="run" type="button"><span class="action-label">執行串接</span></button>
kit_button("all", "全選")
#> <button class="btn btn-default action-button btn-sm btn-outline-secondary" id="all" type="button"><span class="action-label">全選</span></button>
kit_button("drop", "這一回合不做", "danger")
#> <button class="btn btn-default action-button btn-sm btn-danger" id="drop" type="button"><span class="action-label">這一回合不做</span></button>
```
