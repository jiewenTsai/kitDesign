# Press a download button in tests

The mock session of
[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
does not really register downloads (`registerDataObj()` does nothing),
so
[`kit_download_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_download_button.md)
stores the download in `session$userData` instead; this function takes
it from there and writes the file and responds the same way as when a
browser presses download.

## Usage

``` r
kit_test_download(session, id, write = TRUE)
```

## Arguments

- session:

  The `session` of
  [`testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html).

- id:

  The button id: inside a module, the id without namespace (`"dl"`); at
  the app level, the full id (`"stack-download_csv"`).

- write:

  When `FALSE`, no file is written and no response is made; only the
  file name registered is checked (for example, downloads that are slow
  to draw a chart).

## Value

[`shiny::httpResponse()`](https://rdrr.io/pkg/shiny/man/httpResponse.html)
(`status`, `content_type`, `headers`, `content$file`), with one more
field `filename`: the file name registered. With `write = FALSE`, only
`list(filename = )`.

## Examples

``` r
session <- shiny::MockShinySession$new()
b <- kit_download_button(session, "dl", "下載", "a.csv", function(file) writeLines("x", file))
res <- kit_test_download(session, "dl")
res$content_type
#> [1] "text/csv; charset=UTF-8"
readLines(res$content$file)
#> [1] "x"
```
