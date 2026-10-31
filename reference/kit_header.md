# KIT header

A lime color block, black border, header shadow; the full logo on the
left, and on the right the tool name, one subtitle line, and one version
line. One per app, at the very top
([`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
already places it). It also sets the browser tab icon (the bean logo for
KIT).

## Usage

``` r
kit_header(
  title,
  subtitle = NULL,
  tagline = NULL,
  version = NULL,
  date = NULL,
  meta_extra = NULL,
  logo = TRUE,
  show_kitdesign = FALSE,
  brand = kit_current_brand()
)
```

## Arguments

- title:

  The tool name (the header h1, also the browser tab title), e.g. "KIT
  資料串接工具" ("KIT data join tool").

- subtitle:

  The subtitle (bold), e.g. the database name "臺灣幼兒發展調查資料庫"
  (the KIT database).

- tagline:

  A phrase after the subtitle (e.g. "跨波次資料處理", "cross-wave data
  processing"); `NULL` shows nothing.

- version, date:

  Version and date for the header's version line, usually read from the
  app's own DESCRIPTION: `kit_app_description("kitJoin")`.

- meta_extra:

  Text appended to the version line (e.g. "kits 0.25.0").

- logo:

  Whether the header shows the brand logo (KIT's is the bean plus the
  KIT wordmark): `TRUE` (the logo file is served by an htmlDependency;
  for use in Shiny), `"inline"` (the logo is written into the page, for
  a standalone HTML file without Shiny, such as a user manual), or
  `FALSE`.

- show_kitdesign:

  Whether to append the kitDesign version to the version line
  ("kitDesign 0.1.0"), so both versions are visible when reporting a
  problem.

- brand:

  The brand: logo, tab icon, colors
  ([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)).
  Defaults to
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md):
  KIT when `options(kitDesign.brand = )` is not set.

## Value

`<div class="kit-header mb-4">`.

## Details

Logo, tab icon, and colors come from the brand
([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)).
When the brand's colors differ from KIT's, the header adds a short
`<style>` that overrides the differing `--nb-*` variables; for the KIT
brand nothing is added and the page is the same as before.

## Examples

``` r
kit_header("KIT 資料串接工具", "臺灣幼兒發展調查資料庫", tagline = "跨波次資料處理",
           version = "0.5.0", date = "2026-10-31")
#> <div class="kit-header mb-4">
#>   <div class="kit-header-row">
#>     <img src="kitDesign-logo-0.4.0/kit-logo.svg" alt="KIT 標誌" class="kit-header-logo"/>
#>     <div>
#>       <h1>KIT 資料串接工具</h1>
#>       <p>
#>         <span class="kit-subtitle">臺灣幼兒發展調查資料庫</span>
#>          · 
#>         跨波次資料處理
#>       </p>
#>       <div class="kit-app-meta">v0.5.0 · 2026-10-31</div>
#>     </div>
#>   </div>
#> </div>
```
