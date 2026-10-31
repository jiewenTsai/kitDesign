# 把分頁狀態送到瀏覽器

兩種分頁列都適用：分組分頁列（[`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md)，`data-tabset`
是 `tabset`）與
流程分頁（[`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/reference/kit_flow_tabs.md)，`id`
是 `tabset`）。

## Usage

``` r
kit_send_tab_states(states, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- states:

  [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md)
  的結果。

- session:

  預設是目前的 session。

## Value

不可見的 `states`。

## Examples

``` r
if (interactive()) kit_send_tab_states(kit_tab_states(list(upload = "success")))
```
