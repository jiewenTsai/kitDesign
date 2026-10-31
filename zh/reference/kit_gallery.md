# 元件樣張 app

一個 app 裡放了每一個元件，內容是 KIT 的例子。 原始碼在
`system.file("examples/gallery", package = "kitDesign")`。

## Usage

``` r
kit_gallery(..., brand = NULL)
```

## Arguments

- ...:

  傳給 [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html)
  的參數（例如 `port = 7551`、`launch.browser = FALSE`）。

- brand:

  用哪個品牌看：`NULL`（預設）是現在的品牌（[`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_current_brand.md)，通常是
  KIT）； `"demo"` 是一個藍色系的示範品牌（看換品牌以後的樣子）；或一個
  [`kit_brand()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_brand.md)。

## Value

[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html)
的結果（app 關掉時）。

## Examples

``` r
if (interactive()) kit_gallery()
if (interactive()) kit_gallery(brand = "demo")
```
