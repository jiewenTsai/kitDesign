# 設定摘要：主要按鈕或結果上面一行小字

例如「本次：5 個檔案 · ID：各檔各自 · 全勤樣本」。

## Usage

``` r
kit_settings_line(parts, prefix = "本次：")
```

## Arguments

- parts:

  各段文字（空字串、`NA` 與 `NULL` 略過），用「 · 」接起來；
  也可以是已經寫好的一整句（kitsUI 的 `ui_settings_line(text)`，這時用
  `prefix = NULL`）。

- prefix:

  前面的字，預設「本次：」；`NULL` 不加。

## Value

`<p class="kit-settings-line">`；沒有任何一段時是 `NULL`。

## Examples

``` r
kit_settings_line(c("5 個檔案", "ID：各檔各自", "全勤樣本"))
#> <p class="kit-settings-line">本次：5 個檔案 · ID：各檔各自 · 全勤樣本</p>
kit_settings_line("本回合 R1：M03、M36 · 參照世代 M03", prefix = NULL)
#> <p class="kit-settings-line">本回合 R1：M03、M36 · 參照世代 M03</p>
```
