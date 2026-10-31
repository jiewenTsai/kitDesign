# Start a new KIT Shiny app

Creates a ready-to-run app package skeleton, with one example tab
written to the KIT design language's page skeleton:

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

  The new folder (the last part is the package name, e.g.
  `"~/kitScore"`).

- title:

  The tool name, e.g. "KIT 計分工具" ("KIT scoring tool").

- subtitle:

  The subtitle, e.g. "臺灣幼兒發展調查資料庫" (the KIT database).

- package:

  The package name (defaults to the folder name): starts with a letter
  and contains only letters, digits, and periods.

## Value

`path` (full path), invisibly.

## Details

- `DESCRIPTION`: `Imports: kitDesign (>= current version)`,
  `Remotes: jiewenTsai/kitDesign@v<current version>`.

- `app.R`: the entry point for Posit Connect Cloud (primary file).

- `R/app.R`:
  [`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
  plus the step tabs module
  ([`kit_step_tabs_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md));
  `run_app()`.

- `R/page_calc.R`: an example tab using a primary button plus the ready
  line
  ([`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)),
  a status box, a result table, "How to do it in R"
  ([`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)),
  and next step.

- `tests/testthat/`: one
  [`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
  test.

- `.gitignore` (including `tests/testthat/_problems/` and
  `testthat-problems.rds`), `.Rbuildignore`, `README.md`, `LICENSE`.

If the folder already exists and is not empty, it does nothing and stops
(it never overwrites any file).

## Examples

``` r
dir <- file.path(tempdir(), "kitDemo")
kit_new_app(dir, "KIT 示範工具", "臺灣幼兒發展調查資料庫")  # "KIT demo tool", the KIT database
list.files(dir, recursive = TRUE)
#> [1] "DESCRIPTION"               "LICENSE"                  
#> [3] "NAMESPACE"                 "R/app.R"                  
#> [5] "R/page_calc.R"             "README.md"                
#> [7] "app.R"                     "tests/testthat.R"         
#> [9] "tests/testthat/test-app.R"
unlink(dir, recursive = TRUE)
```
