# KIT 的樣式與瀏覽器端小程式（htmltools 的 dependency）

放進頁面任何地方都可以（htmltools 會把它搬到 `<head>`）。裡面有：

## Usage

``` r
use_kit()
```

## Value

[`htmltools::htmlDependency()`](https://rstudio.github.io/htmltools/reference/htmlDependency.html)
物件。

## Details

- `kit-base.css`：頁首、說明框、提示框等基本樣式（原本的
  `kit_css()`、`kit_css_guide()`）。

- `kit-brite.css`：KIT 的 neo-brutalism 樣式（原本的
  `kit_css_brite()`）。

- `kit-design.css`：kitDesign
  新加的少數規則（頁首排版、流程分頁的虛線分頁、程式碼框的寬度）。

- `kit.js`：收合區塊、分頁列、分頁狀態、捲到結果、離開前提醒、「複製」按鈕。

用
[`kit_page()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_page.md)
時已經加好了；自己用 `bslib::page_*()` 組頁面時才需要放
`use_kit()`，並把 `theme = kit_theme()` 傳給頁面。

## Examples

``` r
use_kit()
#> List of 10
#>  $ name      : chr "kitDesign"
#>  $ version   : chr "0.5.2"
#>  $ src       :List of 1
#>   ..$ file: chr "www"
#>  $ meta      : NULL
#>  $ script    : chr "kit.js"
#>  $ stylesheet: chr [1:3] "kit-base.css" "kit-brite.css" "kit-design.css"
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : chr "kitDesign"
#>  $ all_files : logi FALSE
#>  - attr(*, "class")= chr "html_dependency"
```
