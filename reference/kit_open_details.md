# 打開一個收合區塊（例如套用預設後打開進階設定）

打開一個收合區塊（例如套用預設後打開進階設定）

## Usage

``` r
kit_open_details(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  `<details>` 的 id（模組內的 id，會自動加上 namespace），例如
  [`kit_advanced()`](https://jiewentsai.github.io/kitDesign/reference/kit_advanced.md)
  的 `id`。

- session:

  預設是目前的 session。

## Value

不可見的完整 id；沒有 session 時是 `NULL`。

## Examples

``` r
if (interactive()) kit_open_details("advanced")
```
