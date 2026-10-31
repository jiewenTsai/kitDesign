# 提示框（Callout）

按下去之前就該知道的提醒，不是結果，所以沒有陰影。一個區塊最多一個；
能寫進狀態框的，就不要另外開提示框；有按鈕時，按鈕放在框外面。

## Usage

``` r
kit_callout(..., warn = FALSE, class = NULL)
```

## Arguments

- ...:

  框裡的內容。

- warn:

  `FALSE`：天藍的資訊；`TRUE`：黃色的注意。

- class:

  另外加的 class。

## Value

`<div class="kit-callout">`（注意時再加 `kit-callout-warn`）。

## Examples

``` r
kit_callout("外部連結不適用：這一回合只有一個世代，這不是錯誤。")
#> <div class="kit-callout">外部連結不適用：這一回合只有一個世代，這不是錯誤。</div>
kit_callout("資料裡有疑似遺漏值代碼，建議先到「遺漏值處理」。", warn = TRUE)
#> <div class="kit-callout kit-callout-warn">資料裡有疑似遺漏值代碼，建議先到「遺漏值處理」。</div>
```
