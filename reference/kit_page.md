# A KIT page: theme, styles, and header set up in one call

Wraps
`bslib::page_fluid(lang = "zh-Hant-TW", theme = kit_theme(), use_kit(), kit_header(...), ...)`.
Below the header, put the tab bar
([`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md)
or
[`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/reference/kit_flow_tabs.md))
and the content of each tab.

## Usage

``` r
kit_page(
  title,
  subtitle = NULL,
  ...,
  tagline = NULL,
  version = NULL,
  date = NULL,
  logo = TRUE,
  meta_extra = NULL,
  window_title = title,
  show_kitdesign = FALSE,
  brand = kit_current_brand()
)
```

## Arguments

- title:

  The tool name (the header's h1, also the browser tab title), for
  example "KIT 資料串接工具" ("KIT data join tool").

- subtitle:

  The subtitle (bold), for example the database name
  "臺灣幼兒發展調查資料庫" (the KIT database).

- ...:

  The page content.

- tagline:

  A phrase after the subtitle (for example "跨波次資料處理", "cross-wave
  data processing"); `NULL` shows nothing.

- version, date:

  The version and date on the header's version line, usually read from
  the app's own DESCRIPTION: `kit_app_description("kitJoin")`.

- logo:

  Whether the header shows the brand logo (KIT's is the bean plus the
  KIT wordmark): `TRUE` (the logo file comes from an htmlDependency; use
  in Shiny), `"inline"` (the logo is written into the page, for single
  HTML files without Shiny, such as user manuals), or `FALSE`.

- meta_extra:

  Text added after the version line (for example "kits 0.25.0").

- window_title:

  The browser tab title (defaults to `title`).

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

## Value

A complete page
([`bslib::page_fluid()`](https://rstudio.github.io/bslib/reference/page.html)).

## See also

[`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md),
[`kit_app_description()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_description.md)

## Examples

``` r
if (interactive()) {
  ui <- kit_page(
    "KIT ×× 工具", "臺灣幼兒發展調查資料庫",
    tagline = "跨波次資料處理", version = "0.1.0", date = "2026-10-31",
    kit_tab_guide("示範一頁。", kit_steps("選檔案", "按執行"), "一張表。")
  )
  shiny::shinyApp(ui, function(input, output, session) {})
}
```
