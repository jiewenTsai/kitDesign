# Cloud version reminder banner (one line below the header)

A yellow line reminding users that their data go to the cloud. The app
writes the text itself (each app's server location and usage notes
differ).

## Usage

``` r
kit_cloud_banner(...)
```

## Arguments

- ...:

  The banner content.

## Value

`<div class="alert alert-warning kit-cloud-banner" role="alert">`.

## Examples

``` r
kit_cloud_banner("此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。")
#> <div class="alert alert-warning kit-cloud-banner" role="alert">此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。</div>
# "This is the cloud version: uploaded data are sent to a cloud server. For data with personal information, use the local version."
```
