# Is this the cloud version?

Checks the environment variable `KIT_DEPLOY` first (`"cloud"` or
`"local"`, set in Connect Cloud); if it is not set, Posit Connect's
default `R_CONFIG_ACTIVE = "rsconnect"` counts as the cloud version.

## Usage

``` r
kit_is_cloud()
```

## Value

`TRUE` or `FALSE`.

## See also

[`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md),
[`kit_cloud_footer()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_footer.md)

## Examples

``` r
kit_is_cloud()
#> [1] FALSE
```
