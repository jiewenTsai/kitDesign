# kitDesign 0.5.1 (2026-11-01)

## 修正

* Firefox: clicking a download button showed the "leave page" warning; choosing Leave Page really left
  the page, the connection closed, and the download was Not Found. Downloads no longer leave the page:
  `kit.js` fetches the file in the background and saves it (in every browser). While downloading the
  button is dimmed and cannot be clicked again (`.kit-downloading`).
* `?kitDesign` and every function's help are now in English (help in R, the English website). The Chinese
  help is kept in `pkgdown/zh/man/` for the Chinese website.

# kitDesign 0.5.0 (2026-11-01)

minor: the version line can show the app's name; existing apps need no changes and their screens do not change.

## 元件

* `kit_page()`, `kit_header()` and `kit_app_meta()` gain `package`: the app's package name goes at the start
  of the version line, "kitsUI v0.5.0 · 2026-10-31 · kits 0.25.2". When someone reports a problem, you can
  see at once which app and which version it is. The default `NULL` writes no name, as before.

# kitDesign 0.4.0 (2026-10-31)

minor: mechanisms that kitJoin and kitsUI each had their own copy of move into kitDesign; existing apps need no changes, and both apps' screens and downloaded files are exactly the same.

## Components

* File helpers (previously identical copies in both kitJoin and kitsUI): `kit_fix_utf8_chr()`, `kit_fix_utf8_df()`,
  `kit_is_valid_utf8_df()`, `kit_sav_safe_names()`, `kit_truncate_bytes()`, `kit_gz_path()`, `kit_open_browser()`.
* `kit_download_button(session, id, label, filename, content, class, app)`: download button (moved from both apps'
  `R/download.R`). Chinese file names save correctly in every browser: the last segment of the URL, `Content-Disposition`
  (`filename` and the UTF-8 `filename*`), and `<a download>` all use the same file name. `.csv`, `.zip`, and `.html`
  get their own MIME types; everything else is `application/octet-stream`. If writing the file fails, it writes to the log, shows a red notification, and returns 500.
  `app` (default `getOption("kitDesign.app", "kit")`) is the app name in the log, and also the lowercase
  ASCII fallback name for file names that are entirely Chinese; the app sets it once in `.onLoad()`.
* `kit_test_download(session, id, write = TRUE)`: clicks download inside `shiny::testServer()` and returns the
  `httpResponse` and the file name.
* `kit_is_cloud()`: whether this is the cloud version (`KIT_DEPLOY`; if not set, checks `R_CONFIG_ACTIVE = "rsconnect"`).
* `kit_cloud_footer(sections, links, title, id)`: cloud-version usage notes (small gray text in the footer);
  the app supplies each section's title and text and the reference links. `kit_cloud_banner()` moved to the same file (`R/cloud.R`).
* `kit_run_tab_ui()`/`kit_run_tab_server()`: the run tab skeleton (all six kitJoin tabs look like this).
  The UI follows the page skeleton: what this page does → the tab's own settings (`...`) → settings summary → still needed → primary button → status box →
  key results → downloads → details row (result details, "How to do it in R") → next step. The server is called inside the tab's `moduleServer()`
  and handles the state flow: still needed and disabling, settings summary, the click (`guard()` → `run()` inside a progress bar → `done(result)`; on error,
  `error(e)`) → status box, notification, scroll to the status box; settings changed (`stale_on()`) → 【要重新執行】 ("Needs re-run"); key results,
  details, and "How to do it in R". Errors that need user confirmation (`confirm`) open a dialog instead of a notification. Returns `result`, `status`,
  `state`, `run(...)`. Not a Shiny module: the settings inputs stay in the tab's own namespace, and ids are unchanged
  (`<tab>-run`, `<tab>-status`, `<tab>-code`, ...).

# kitDesign 0.3.0 (2026-10-31)

minor: new functions and options; existing apps need no changes; KIT's screens are exactly the same.

## Components

* `kit_brand()`: a brand object (S3). The logo and colors are no longer hard-coded, so projects other than KIT can use the package.
  `kit_brand(name, logo, mark, logo_alt, colors)`: `logo` is the header logo, `mark` is the browser-tab
  icon (SVG or PNG; files are read in when the object is created); `colors` replaces colors using the design language names:
  `ink`, `page`, `card`, `accent` (`--nb-lime`), `accent_light` (`--nb-bg-new`),
  `primary` (`--nb-green`), `primary_hover` (`--nb-green-hover`), `success` (`--nb-mint`),
  `warning` (`--nb-yellow`), `danger` (`--nb-salmon`), `info` (`--nb-sky`).
  Unknown names stop with an error that lists the names you can use. With no arguments it is KIT.
* `kit_current_brand()`: set `options(kitDesign.brand = kit_brand(...))` once and every function uses it;
  when not set, it is KIT.
* `kit_page()`, `kit_header()`, `kit_theme()`, `kit_colors()`, `kit_chart_sequential()`, and
  `kit_plotly_style()` gain a `brand =` argument (default `kit_current_brand()`):
  - The header logo, alt text, and tab icon come from the brand; in Shiny, your own logo files are served by an
    htmlDependency that contains only those files; with `logo = "inline"` they are written as data URIs.
  - When the colors differ from KIT, the header gets a short `<style>html:root { --nb-…: … }</style>`; the bslib theme's
    `primary`, `link-color`, `body-bg`, and `border-color` change too. The KIT brand does not add this block.
  - The heatmap color scale comes from the brand (the light end is a very light tint of `accent_light`, interpolated in Lab space to `primary`);
    the categorical colors (Okabe–Ito) do not change, so they stay colorblind-friendly.
* `kit_gallery(brand = "demo")`: see all components with a blue demo brand; the third argument
  `demo` to `tools/check_gallery.R` does the same. The demo logos are in `inst/examples/brand/`.
* The README from `kit_new_app()` adds a `brand =` example.

## Styles

* The CSS in `inst/www/` no longer hard-codes KIT's brand colors: `kit-base.css` and `kit-brite.css` now use `--nb-*` variables;
  `kit-brite.css`'s `:root` gains two variables: `--nb-green-hover` and `--nb-bg-new`. KIT's values are unchanged, and so are the screens.

## Fixes

* `kit_theme()` no longer reads `_brand.yml` from the working directory or parent folders (since bslib 0.9, `bs_theme()` looks for it on its own,
  for example `brand/_brand.yml`): the brand comes only from `kit_brand()`. Where there is no `_brand.yml` (deployed apps)
  the theme is exactly the same; during development, a `_brand.yml` nearby used to override the fonts and colors.

## Development

* Website (pkgdown, `_pkgdown.yml`, `pkgdown/extra.css`, `vignettes/articles/`): home page, getting started,
  component overview (components rendered directly on the page, with the code beside them), charts, switching to another brand, design language, versions and releases, function reference
  (grouped by component), changelog. `.github/workflows/pkgdown.yaml` builds the site on push to main and
  deploys it to the `gh-pages` branch; `docs/` is not tracked in git. Locally: `pkgdown::build_site()`.

# kitDesign 0.2.0 (2026-10-31)

minor: new functions and options; existing apps need no changes.

## Components

* `kit_plotly_style()`: applies the KIT look to plotly charts (for example from kits' `plot()`) so they match the app.
  Rounded typeface, `nb-ink` text and axis lines, `text-hint` tick labels, `line-soft` gridlines, `line` zero lines, white background, left-aligned bold title
  (wraps when it doesn't fit), every axis (including side-by-side subplots), an Okabe–Ito `colorway` (plotly's default colors are replaced with the Okabe–Ito color
  in the same position; colors you set are left alone), heatmaps switched to the KIT color scale, white hover boxes with black borders, legend placement
  (moved below when there are more than 4 entries or they are too long, or the chart is narrower than 600px), a trimmed toolbar (download PNG, zoom in, zoom out,
  reset to the original range; no plotly logo; Traditional Chinese). It only changes the look, not the data.
  `legend = "keep"` and `colorscale = FALSE` keep the legend position and color scale unchanged.
  Order when used with kits and kitsUI: kits' `plot()` → kitsUI recolor → kitsUI switch to Chinese → `kit_plotly_style()`.
* `kit_plotly_fonts()`: attaches the rounded typeface from Google Fonts to plotly charts (`data-external`, so saving as a single HTML file
  does not embed the font files); downloaded HTML uses the app's fonts too. `kit_plotly_style()` attaches it by default.
* `kit_chart_sequential()`: color scale for continuous values (very light lime `#f3f7d3` → `bg-new` → `nb-green`). The minimum is not white, so 0% is distinguishable from blank cells that were not administered (white background).
* plotly and htmlwidgets are in Suggests: apps that don't use `kit_plotly_style()` don't need to install them; without plotly,
  `kit_plotly_style()` stops and says what to install.
* The "圖" ("Charts") tab in the component sample app now shows two styled plotly charts (a line chart by cohort, and an item × wave heatmap).

## Visible changes

* Danger buttons (`kit_button(kind = "danger")`) have a salmon (`nb-salmon`) background with ink text, including on hover and when pressed;
  before, the secondary button's white background overrode it and it looked white. Disabled danger buttons use the disabled look. The design language already said this,
  so this is a fix; but the screen changes, so check pages with danger buttons when upgrading.
  `tools/check_gallery.R` also checks the danger button color.

## Fixes

* `kit_theme()`: when bslib is older than 0.11.0 (no Brite theme), it stops first and says to update bslib,
  instead of failing inside bslib.
* README from `kit_new_app()`: install with `pak::pkg_install("<帳號>/<app>")` or
  `remotes::install_github(..., upgrade = "always")` so outdated packages (for example bslib) are upgraded too.

# kitDesign 0.1.0 (2026-10-31)

First version: merges the separate interfaces of kitJoin 0.5.0 and kitsUI 0.4.0 into one package (phase 1).
The two apps do not use it yet (phases 2 and 3); for the name mapping, see `brand/en/migration.md`.

## Setup

* `kit_page()`, `kit_theme()`, `use_kit()`, `kit_header()`, `kit_app_meta()`,
  `kit_app_description()`, `kit_versions()`, `kit_logo_uri()`, `kit_colors()`.
* Styles moved from R strings to `inst/www/` (`kit-base.css`, `kit-brite.css`, `kit-design.css`),
  and scripts are in `inst/www/kit.js`; the screens are the same as kitJoin 0.5.0 and kitsUI 0.4.0.
* The header's version line can include the kitDesign version (`show_kitdesign = TRUE`).

## Components

* Page guide, buttons, callout, details row, advanced settings, settings summary, still needed, next step, diagram, data table,
  step cards, checklist, step tabs (flow and grouped), chart colors.
* Value objects: `kit_status`, `kit_check`/`kit_checklist`, `kit_code` (with `as.tags()`,
  `format()`, `print()`; contents checked at construction).
* Modules: `kit_stepcards_*`, `kit_step_tabs_*`, `kit_run_gate_*`, `kit_code_panel_*`.
* "How to do it in R" wraps to at most 70 columns per line: `kit_code_wrap()`, `kit_code_cols()` (algorithm from kitJoin).

## Fixes

* When "How to do it in R" is open, a very long line of code no longer stretches the layout (`.kit-details > .kit-detail`
  gets `min-width: 0`).

## Development

* `kit_new_app()`: creates a new KIT app package skeleton.
* `kit_gallery()`: a sample app with every component.
* `vignette("kitDesign")`: build a page step by step.
