# 還差什麼（ReadyLine）

主要按鈕還不能按時，按鈕上面一行粗體「還差：…」，後面接一個去處理的連結。
「還差」寫具體的事和數字：「至少要 2 個波次的檔案，目前只有 1 個」。

## Usage

``` r
kit_ready_line(missing, link = NULL)
```

## Arguments

- missing:

  還差的事（字串向量；`NA` 與 `""` 略過）。

- link:

  跟在後面的連結（例如「到「檔案上傳」加入檔案 →」）；`NULL` 不顯示。

## Value

`<p class="kit-ready todo">`；不差什麼時是 `NULL`。

## See also

[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md)、[`kit_need_files()`](https://jiewentsai.github.io/kitDesign/reference/kit_need_files.md)

## Examples

``` r
kit_ready_line(c("至少要 2 個波次的檔案，目前只有 1 個", "選 ID 欄"))
#> <p class="kit-ready todo">還差：至少要 2 個波次的檔案，目前只有 1 個；選 ID 欄。</p>
```
