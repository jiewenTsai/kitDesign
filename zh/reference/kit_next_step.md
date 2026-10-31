# 下一步（NextStep）

頁面最下面、靠右：左邊一句小字（可以是幾個去處的清單），右邊一個按鈕
「下一步：××× →」。結果出來以後（【完成】或【完成，但請注意】）才顯示；
結果過期（【要重新執行】）時拿掉。

## Usage

``` r
kit_next_step(
  text = NULL,
  button_id = NULL,
  label = NULL,
  button = NULL,
  kind = "primary"
)
```

## Arguments

- text:

  左邊的小字；`NULL` 不顯示。

- button_id:

  按鈕的 id；`NULL` 時不畫按鈕（除非給了 `button`）。

- label:

  按鈕的字，例如「下一步：橫向資料串接」；後面自動加「 →」。

- button:

  不用 actionButton 時直接給按鈕（例如連到別的 app 的連結）。

- kind:

  按鈕的種類：預設是主要按鈕；這一頁另有主角時（例如下載）用
  `"secondary"`。

## Value

`<div class="kit-next">`。

## Examples

``` r
kit_next_step("串接好了，可以接著做 kits 作答檔。", "next", "下一步：kits 作答檔")
#> <div class="kit-next">
#>   <div class="kit-hint">串接好了，可以接著做 kits 作答檔。</div>
#>   <button class="btn btn-default action-button btn-primary" id="next" type="button"><span class="action-label">下一步：kits 作答檔 →</span></button>
#> </div>
```
