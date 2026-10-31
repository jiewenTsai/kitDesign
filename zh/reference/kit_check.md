# 檢查清單的一列（Checklist）

一個 S3 值物件（class `kit_check`）：建構時檢查內容；有
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html)
方法， 直接放進頁面就畫成 `<li class="kit-check">`。通常放進
[`kit_checklist()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_checklist.md)。

## Usage

``` r
kit_check(state = c("todo", "ok", "note"), title, why = "", actions = NULL)

# S3 method for class 'kit_check'
as.tags(x, ...)

# S3 method for class 'kit_check'
format(x, ...)

# S3 method for class 'kit_check'
print(x, ...)
```

## Arguments

- state:

  `"todo"`、`"ok"` 或 `"note"`。

- title:

  一句話（字串）。

- why:

  下面的小字（為什麼）；`""` 或長度 0 不顯示。（kitJoin 的
  `kitsdata_check()` 叫 `text`）

- actions:

  決定的按鈕（tag 或 tag 的 list）；放在說明下面。

- x:

  `kit_check` 物件。

- ...:

  不用。

## Value

`kit_check` 物件。

## Details

左邊一個記號，前面有看不見的文字（螢幕閱讀器會念）：

- `"todo"`：**!**
  要決定（「要決定：」）。粗體一句話，下面一行小字說為什麼，再下面是決定的按鈕。

- `"ok"`：**✓** 沒問題，或已經決定（「沒問題：」）。字重 500。

- `"note"`：**i** 提醒，不用決定（「提醒：」）。

建議的選項放第一個，按鈕上寫「（建議）」。

## Examples

``` r
kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。")
#> ! 有 3 題的分數從 1 開始（kits 要的分數是 0、1、2…。）
htmltools::as.tags(kit_check("ok", "45 題的分數都是整數"))
#> <li class="kit-check ok">
#>   <span class="kit-check-mark" aria-hidden="true">✓</span>
#>   <span class="visually-hidden">沒問題：</span>
#>   <div class="kit-check-text">
#>     <strong>45 題的分數都是整數</strong>
#>   </div>
#> </li>
```
