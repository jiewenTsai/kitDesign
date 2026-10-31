# 雲端版的提醒橫幅（頁首下面一行）

黃色的一行，提醒使用者資料會傳到雲端。文字由 app 自己寫（各 app
的伺服器位置、 使用須知不同）。

## Usage

``` r
kit_cloud_banner(...)
```

## Arguments

- ...:

  橫幅的內容。

## Value

`<div class="alert alert-warning kit-cloud-banner" role="alert">`。

## Examples

``` r
kit_cloud_banner("此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。")
#> <div class="alert alert-warning kit-cloud-banner" role="alert">此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。</div>
```
