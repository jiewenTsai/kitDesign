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
  brand = kit_current_brand(),
  package = NULL
)
```

## Arguments

- title:

  The tool name (the header's h1, also the browser tab title), for
  example "KIT 資料串接工具" ("KIT data join tool").

- subtitle:

  The subtitle (bold), for example the database name
  "臺灣幼兒發展調查資料庫" (the KIT database).

- tagline:

  A phrase after the subtitle (for example "跨波次資料處理", "cross-wave
  data processing"); `NULL` shows nothing.

- version, date:

  The version and date on the header's version line, usually read from
  the app's own DESCRIPTION: `kit_app_description("kitJoin")`.

- meta_extra:

  Text added after the version line (for example "kits 0.25.0").

- logo:

  Whether the header shows the brand logo (KIT's is the bean plus the
  KIT wordmark): `TRUE` (the logo file comes from an htmlDependency; use
  in Shiny), `"inline"` (the logo is written into the page, for single
  HTML files without Shiny, such as user manuals), or `FALSE`.

- show_kitdesign:

  Whether to add the kitDesign version after the version line
  ("kitDesign 0.1.0"), so both versions are visible when someone reports
  a problem.

- brand:

  The brand: logo, tab icon, and colors
  ([`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)).
  Defaults to
  [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md):
  KIT when `options(kitDesign.brand = )` is not set.

- package:

  The app's package name, written at the start of the version line:
  "kitJoin v0.6.0 · 2026-10-31". Anyone reporting a problem can see at
  once which app and which version. `NULL` (the default) writes no name,
  as before.

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
           version = "0.6.0", date = "2026-10-31", package = "kitJoin")
#> <div class="kit-header mb-4">
#>   <div class="kit-header-row">
#>     <img src="kitDesign-logo-0.5.2/kit-logo.svg" alt="KIT 標誌" class="kit-header-logo"/>
#>     <div>
#>       <h1>KIT 資料串接工具</h1>
#>       <p>
#>         <span class="kit-subtitle">臺灣幼兒發展調查資料庫</span>
#>          · 
#>         跨波次資料處理
#>       </p>
#>       <div class="kit-app-meta">kitJoin v0.6.0 · 2026-10-31</div>
#>     </div>
#>   </div>
#> </div>
```
