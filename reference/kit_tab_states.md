# State of each tab

Works out how each tab looks from the state of its status box (the
`state` of
[`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)):

## Usage

``` r
kit_tab_states(
  status,
  locked = character(0),
  locked_tips = NULL,
  tabset = "tabs"
)
```

## Arguments

- status:

  A named list or character vector: names are tab values, values are
  states. Tabs not listed are left unchanged.

- locked:

  Tabs that cannot be used yet: a character vector of values, or a named
  logical.

- locked_tips:

  The hover text for tabs that cannot be used yet: one string (the same
  for all), or a character vector named by value.

- tabset:

  The tabset id (`tabsetPanel(id = )`).

## Value

A list with one `list(tabset, value, state, tip)` per tab.

## Details

- `"locked"` (gray): tabs listed in `locked`. The hover text is
  `locked_tips`.

- `"done"` (with ✓): the state is `"success"` or `"warning"` (or
  directly `"done"`).

- `"stale"` (✓ removed): the state is `"stale"`.

- `"ready"`: anything else (`"idle"`, `"error"`, `"ready"`).

Pass the result to
[`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_send_tab_states.md)
(or
[`kit_watch_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_watch_tab_states.md))
to send it to the browser.

## Examples

``` r
kit_tab_states(
  list(upload = "success", missing = "stale", join = "idle"),
  locked = "join", locked_tips = c(join = "還不能用：先加入至少 2 個檔案")
)
#> [[1]]
#> [[1]]$tabset
#> [1] "tabs"
#> 
#> [[1]]$value
#> [1] "upload"
#> 
#> [[1]]$state
#> [1] "done"
#> 
#> [[1]]$tip
#> [1] "已完成"
#> 
#> 
#> [[2]]
#> [[2]]$tabset
#> [1] "tabs"
#> 
#> [[2]]$value
#> [1] "missing"
#> 
#> [[2]]$state
#> [1] "stale"
#> 
#> [[2]]$tip
#> [1] "設定或檔案改過了：要重新執行"
#> 
#> 
#> [[3]]
#> [[3]]$tabset
#> [1] "tabs"
#> 
#> [[3]]$value
#> [1] "join"
#> 
#> [[3]]$state
#> [1] "locked"
#> 
#> [[3]]$tip
#> [1] "還不能用：先加入至少 2 個檔案"
#> 
#> 
```
