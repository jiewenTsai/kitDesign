# 是不是雲端版

先看環境變數 `KIT_DEPLOY`（`"cloud"` 或 `"local"`，在 Connect Cloud
設定）； 沒有設定時，Posit Connect 預設的
`R_CONFIG_ACTIVE = "rsconnect"` 就算雲端版。

## Usage

``` r
kit_is_cloud()
```

## Value

`TRUE` 或 `FALSE`。

## See also

[`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md)、[`kit_cloud_footer()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_footer.md)

## Examples

``` r
kit_is_cloud()
#> [1] FALSE
```
