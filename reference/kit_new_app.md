# 開一個新的 KIT Shiny app

建立一個可以直接執行的 app 套件骨架，照 KIT
設計語言的頁面骨架寫好一個範例分頁：

## Usage

``` r
kit_new_app(
  path,
  title,
  subtitle = "臺灣幼兒發展調查資料庫",
  package = basename(path)
)
```

## Arguments

- path:

  新的資料夾（最後一層是套件名稱，例如 `"~/kitScore"`）。

- title:

  工具名稱，例如「KIT 計分工具」。

- subtitle:

  副標，例如「臺灣幼兒發展調查資料庫」。

- package:

  套件名稱（預設是資料夾名稱）：英文字母開頭，只有英文字母、數字和點。

## Value

不可見的 `path`（完整路徑）。

## Details

- `DESCRIPTION`：`Imports: kitDesign (>= 目前版本)`、`Remotes: jiewenTsai/kitDesign@v目前版本`。

- `app.R`：Posit Connect Cloud 的入口（primary file）。

- `R/app.R`：[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)＋步驟分頁模組（[`kit_step_tabs_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)）；`run_app()`。

- `R/page_calc.R`：範例分頁，用了主要按鈕＋還差（[`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)）、狀態框、結果表、
  用 R
  怎麼做（[`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)）、下一步。

- `tests/testthat/`：一個
  [`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
  測試。

- `.gitignore`（含
  `tests/testthat/_problems/`、`testthat-problems.rds`）、`.Rbuildignore`、
  `README.md`、`LICENSE`。

資料夾已經存在而且不是空的時候，什麼都不做、停下來（不會蓋掉任何檔案）。

## Examples

``` r
dir <- file.path(tempdir(), "kitDemo")
kit_new_app(dir, "KIT 示範工具", "臺灣幼兒發展調查資料庫")
list.files(dir, recursive = TRUE)
#> [1] "DESCRIPTION"               "LICENSE"                  
#> [3] "NAMESPACE"                 "R/app.R"                  
#> [5] "R/page_calc.R"             "README.md"                
#> [7] "app.R"                     "tests/testthat.R"         
#> [9] "tests/testthat/test-app.R"
unlink(dir, recursive = TRUE)
```
