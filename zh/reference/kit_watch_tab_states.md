# 分頁狀態一變就送到瀏覽器

`kit_watch_tab_states(session, shiny::reactive(kit_tab_states(...)))`。

## Usage

``` r
kit_watch_tab_states(session, states)
```

## Arguments

- session:

  Shiny session。

- states:

  reactive：[`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_tab_states.md)
  的結果。

## Value

[`shiny::observe()`](https://rdrr.io/pkg/shiny/man/observe.html) 的
observer（不可見）。

## Examples

``` r
if (interactive()) {
  server <- function(input, output, session) {
    kit_watch_tab_states(session, shiny::reactive(kit_tab_states(list(upload = "success"))))
  }
}
```
