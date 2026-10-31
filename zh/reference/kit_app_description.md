# 讀取 app 的版本與日期（DESCRIPTION 的 Version、Date）

雲端版、本機 run.bat、套件的 `run_xxx()` 都以 DESCRIPTION 的
Version、Date 為準，
三者顯示一致（不看檔案修改時間：解壓、安裝、部署都會改變 mtime）。

## Usage

``` r
kit_app_description(package = NULL, path = NULL)
```

## Arguments

- package:

  app 的套件名稱，例如 `"kitJoin"`；`NULL` 時只找 DESCRIPTION 檔。

- path:

  DESCRIPTION 檔的路徑；`NULL` 時照上面的順序找。

## Value

`list(version = , date = )`；找不到的是 `NA`。

## Details

找的順序：

1.  `path` 有給：讀那個 DESCRIPTION 檔。

2.  `package`
    已經載入（[`library()`](https://rdrr.io/r/base/library.html)、`run_xxx()`、`load_all()`）：讀載入的那一份。

3.  工作目錄的 `DESCRIPTION`，再往上一層、兩層找（測試時工作目錄在
    `tests/testthat`）； 有給 `package` 時，只認 `Package:`
    是它的那一份。雲端版與 run.bat 用 `runApp(資料夾)`，
    套件沒有載入，讀的是這一份。

4.  `package`
    有安裝（但沒有載入）：讀安裝的那一份。放在最後，因為它可能是舊版。

## Examples

``` r
kit_app_description("kitDesign")
#> $version
#> [1] "0.4.0"
#> 
#> $date
#> [1] "2026-10-31"
#> 
```
