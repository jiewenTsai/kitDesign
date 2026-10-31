# 每個分頁的狀態

從每個分頁狀態框的狀態（[`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
的 `state`）算出分頁的樣子：

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

  具名 list 或字串向量：名字是分頁的 value，值是狀態。
  沒有列出的分頁不改。

- locked:

  還不能用的分頁：value 的字串向量，或具名 logical。

- locked_tips:

  還不能用時滑過的說明：一個字串（全部一樣），或以 value
  命名的字串向量。

- tabset:

  分頁的 id（`tabsetPanel(id = )`）。

## Value

list，一個分頁一個 `list(tabset, value, state, tip)`。

## Details

- `"locked"`（灰色）：寫在 `locked` 裡的分頁。滑過時的說明是
  `locked_tips`。

- `"done"`（打 ✓）：狀態是 `"success"` 或 `"warning"`（或直接寫
  `"done"`）。

- `"stale"`（✓ 拿掉）：狀態是 `"stale"`。

- `"ready"`：其他（`"idle"`、`"error"`、`"ready"`）。

結果交給
[`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_send_tab_states.md)（或
[`kit_watch_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_watch_tab_states.md)）送到瀏覽器。

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
