# 分頁列的一組（給 [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroups.md)）

分頁列的一組（給
[`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_navgroups.md)）

## Usage

``` r
kit_navgroup(label, tabs, tools = FALSE)
```

## Arguments

- label:

  組標籤（灰色小字），例如「準備」「做出資料（選一個）」「其他工具」。

- tabs:

  具名字串向量：名字是分頁的
  value（`tabPanel(value = )`），值是分頁名稱。

- tools:

  `TRUE` 時是獨立的小工具：虛線框、沒有陰影。

## Value

list（`class = "kit_navgroup"`）。

## Examples

``` r
kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理"))
#> $label
#> [1] "準備"
#> 
#> $tabs
#>       upload      missing 
#>   "檔案上傳" "遺漏值處理" 
#> 
#> $class
#> NULL
#> 
#> attr(,"class")
#> [1] "kit_navgroup"
```
