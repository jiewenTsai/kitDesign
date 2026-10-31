# One group in the tab bar (for [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md))

One group in the tab bar (for
[`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md)).

## Usage

``` r
kit_navgroup(label, tabs, tools = FALSE)
```

## Arguments

- label:

  The group label (small gray text), e.g. "準備" ("Prepare"),
  "做出資料（選一個）" ("Make the data (pick one)"), "其他工具" ("Other
  tools").

- tabs:

  A named character vector: names are tab values (`tabPanel(value = )`),
  values are tab names.

- tools:

  When `TRUE`, these are standalone tools: dashed border, no shadow.

## Value

A list (`class = "kit_navgroup"`).

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
# "Prepare": "File upload", "Missing values"
```
