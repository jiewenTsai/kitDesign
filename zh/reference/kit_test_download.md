# 測試裡按下載按鈕

[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
的假 session 不會真的註冊下載（`registerDataObj()` 什麼都不做），
[`kit_download_button()`](https://jiewentsai.github.io/kitDesign/zh/reference/kit_download_button.md)
改把它存在 `session$userData`；這個函式從那裡拿出來，照瀏覽器
按下載時一樣寫檔、回應。

## Usage

``` r
kit_test_download(session, id, write = TRUE)
```

## Arguments

- session:

  [`testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html) 的
  `session`。

- id:

  按鈕 id：模組裡用不含 namespace 的 id（`"dl"`），app 層用完整的 id
  （`"stack-download_csv"`）。

- write:

  `FALSE` 時不寫檔、不回應，只看註冊時的檔名（例如畫圖很慢的下載）。

## Value

[`shiny::httpResponse()`](https://rdrr.io/pkg/shiny/man/httpResponse.html)（`status`、`content_type`、`headers`、`content$file`），
多一個欄位 `filename`：註冊時的檔名。`write = FALSE` 時只有
`list(filename = )`。

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
