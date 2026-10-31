# 主要按鈕還不能按時：停用它，上面一行寫還差什麼

頁面上放 `shiny::uiOutput(ns("ready"))`，緊接著
`kit_button(ns("run"), ..., "primary", disabled = TRUE)`（一開始停用；伺服器算好以後才打開）。
主要按鈕一開始就顯示，讓人知道這一頁最後要按什麼。

## Usage

``` r
kit_run_gate(
  session,
  output,
  missing,
  link = function() NULL,
  button_id = "run",
  output_id = "ready"
)
```

## Arguments

- session:

  模組的 session。

- output:

  模組的 output。

- missing:

  reactive：還差的事（字串；長度 0 = 可以執行）。

- link:

  function()：跟在「還差」後面的連結（tag 或 `NULL`）。

- button_id:

  主要按鈕的 id（模組內的 id，不加 `ns()`）。

- output_id:

  放「還差」的
  [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html)
  id（模組內的 id）。

## Value

不可見的 `NULL`；在 server 裡呼叫。

## Details

按鈕的
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html)
裡仍要自己檢查一次：停用只是畫面上的，不能當成唯一的防線。

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    kit_run_gate(session, output, shiny::reactive(kit_need_files(1L, need = 2L)))
  }
}
```
