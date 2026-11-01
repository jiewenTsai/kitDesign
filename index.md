# kitDesign

The shared interface layer for KIT research tools (kitJoin, kitsUI, and
future KIT Shiny apps): one setup function puts the theme, styles, logo,
and header in place, and a set of documented `kit_*()` components builds
the page. Every component follows the [KIT design
language](https://github.com/jiewenTsai/kitDesign/blob/main/brand/en/design-language.md):
easy to see, safe to click, results first.

![Sample kitDesign components: a lime header, grouped step tabs, a “what
this page does” guide, and a diagram](reference/figures/hero.jpg)

Sample kitDesign components: a lime header, grouped step tabs, a “what
this page does” guide, and a diagram

- Theme: Bootswatch Brite (bslib 0.11.0 or later) + KIT colors, the
  rounded typeface Chiron GoRound TC, and the monospace JetBrains Mono.
- Brand: the logo and colors are not hard-coded. The default is KIT;
  other projects use
  [`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)
  to switch to their own logo and color palette.
- Style: restrained neo-brutalism (2px black borders, hard shadows, flat
  color blocks with black text), 17px body text, content at most 1140px
  wide.
- Components: header, step tabs, page guide, buttons, download button,
  status box, callout, cloud-version banner and usage notes, details
  row, “How to do it in R”, step cards, checklist, ready line (“what’s
  still needed”), next step, diagram, data table, charts (plotly
  styling).
- Server-side helpers: disable the primary button and say what’s still
  needed, scroll to the status box after a run, mark tabs with ✓,
  notifications, thousands separators, plain-language errors.

## Installation

``` r

# install.packages("remotes")
remotes::install_github("jiewenTsai/kitDesign")
```

Depends only on shiny, bslib (\>= 0.11.0), and htmltools (plus grDevices
and utils, which ship with R).
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
also needs plotly, and
[`kit_dt()`](https://jiewentsai.github.io/kitDesign/reference/kit_dt.md)
needs DT.

If bslib is too old (the Brite theme does not exist before 0.11.0),
[`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)
stops and tells you to install a newer version. When installing an app,
use `pak::pkg_install("<account>/<app>")` or
`remotes::install_github("<account>/<app>", upgrade = "always")` so
outdated packages are upgraded too.

## Quick start

Fastest: create a new app package skeleton (header, step tabs, one
example tab laid out with the page skeleton, and tests are all
included).

``` r

kitDesign::kit_new_app("~/kitScore", "KIT 計分工具", "臺灣幼兒發展調查資料庫")
# "KIT Scoring Tool", "Kids in Taiwan: National Longitudinal Study of Child Development and Care"
```

Writing a page yourself:

``` r

library(shiny)
library(kitDesign)

ui <- kit_page(
  "KIT ×× 工具", "臺灣幼兒發展調查資料庫",
  version = "0.1.0", date = "2026-10-31", package = "kitXxx",
  kit_tab_guide(
    goal = "把兩個波次的檔案依 ID 接成一張寬資料。",  # "Join the files from two waves by ID into one wide table."
    steps = c("選 ID 欄", "按「執行串接」", "看狀態框與結果"),  # "Pick the ID column", "Click 'Run join'", "Check the status box and results"
    output = "一張寬資料：一人一列。"  # "One wide table: one row per person."
  ),
  selectInput("id_col", "ID 欄", c("（還沒選）" = "", "subj_id")),  # "ID column", "(not chosen yet)"
  kit_run_gate_ui("gate", "執行串接"),     # "Still needed: ..." + primary button ("Run join")
  uiOutput("status"),
  kit_details_row(kit_code_panel_ui("code"))
)

server <- function(input, output, session) {
  run <- kit_run_gate_server("gate", reactive(
    if (input$id_col == "") "選 ID 欄"  # "Pick the ID column"
  ))
  status <- reactiveVal(kit_status())
  observeEvent(run(), {
    status(kit_done_status("串接完成：結果共 3,389 列。"))  # "Join complete: 3,389 rows in the result."
    kit_scroll_to("status")              # scroll to the status box after the run
  }, ignoreInit = TRUE)
  output$status <- renderUI(status())    # a kit_status object renders directly
  kit_code_panel_server("code", function() list(
    tidy = "joined <- dplyr::left_join(t1, t2, by = \"subj_id\")"
  ))
}

shinyApp(ui, server)
```

Step-by-step guide:
[`vignette("kitDesign")`](https://jiewentsai.github.io/kitDesign/articles/kitDesign.md).
To see every component:
[`kitDesign::kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md),
or the [component
overview](https://jiewentsai.github.io/kitDesign/articles/components.html)
on the website.

Pass plotly charts (for example from kits’
[`plot()`](https://rdrr.io/r/graphics/plot.default.html)) to
[`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
last:

``` r

p <- plot(item, type = "category")      # plotly chart drawn by kits
p <- kit_chart_zh(kit_chart_categorical(p))   # kitsUI: recolor, switch to Chinese (must come first)
kit_plotly_style(p)                     # last: KIT fonts, axis lines, legend, toolbar
```

## Switching to another brand

Projects other than KIT can use it too: swap the logo and colors;
everything else (fonts, borders, shadows, components) follows the design
language. Set it once at app startup and every function uses it:

``` r

options(kitDesign.brand = kit_brand(
  "示範實驗室",                          # "Demo Lab"
  logo = "logo.svg",                     # logo in the header (SVG or PNG)
  mark = "mark.svg",                     # small browser-tab icon (square; uses logo if not given)
  colors = list(accent = "#9cc0ff", primary = "#1f4fa3", page = "#f5f7fa")
))
```

Or for a single page only: `kit_page(..., brand = kit_brand(...))`. For
the color names (`ink`, `page`, `card`, `accent`, `accent_light`,
`primary`, `primary_hover`, `success`, `warning`, `danger`, `info`) and
how they map to CSS variables (`--nb-*`), see
[`?kit_brand`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md).
Anything not given follows KIT;
[`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)
with no arguments is KIT. To see what the switch looks like:
`kit_gallery(brand = "demo")`.

## Component overview

### Setup

| Function | What it does |
|----|----|
| [`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md) | Whole page: `bslib::page_fluid(lang = "zh-Hant-TW")` + theme + styles + header |
| [`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md) | bslib theme (Bootswatch Brite + KIT colors and fonts) |
| [`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md) | Styles and scripts (htmltools dependency; for building pages yourself) |
| [`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md), [`kit_app_meta()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_meta.md) | Header, version line |
| [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_description.md) | Reads Version and Date from the app’s DESCRIPTION |
| [`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md), [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md) | Brand: logo, tab icon, colors (default KIT; `options(kitDesign.brand = )`) |
| [`kit_logo_uri()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_uri.md), [`kit_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_colors.md) | KIT logo (data URI), brand colors |
| [`kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md) | Component sample app (`brand = "demo"`: see another brand) |
| [`kit_new_app()`](https://jiewentsai.github.io/kitDesign/reference/kit_new_app.md) | Creates a new KIT app package skeleton |
| [`kit_versions()`](https://jiewentsai.github.io/kitDesign/reference/kit_versions.md) | Versions of kitDesign and the app (for reporting problems) |

### Modules (stateful components, one line per page)

| UI | server | What it does | server returns |
|----|----|----|----|
| [`kit_step_tabs_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md) | [`kit_step_tabs_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md) | Step tabs (flow or grouped); ✓ when done, not available yet, needs re-run | `selected()`, `select()`, `states()` |
| [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md) | [`kit_stepcards_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md) | Step cards: which step is open, “對，下一步” (“Yes, next step”), “改” (“Edit”), summary, checks | `current()`, `done()`, [`open()`](https://rdrr.io/r/base/connections.html), `reset()` |
| [`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md) | [`kit_run_gate_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md) | Primary button + “還差：…” (“Still needed: …”) | Number of clicks while it was allowed to run |
| [`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md) | [`kit_code_panel_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md) | “How to do it in R” (computed only when opened) | The current `kit_code` |

### Tab skeleton

| UI | server | What it does | server returns |
|----|----|----|----|
| `kit_run_tab_ui(id, run_label, guide, ..., gate, result, downloads, details, code, next_step)` | `kit_run_tab_server(input, output, session, run_label, run, done, ready, settings, stale_on, progress, error, guard, confirm, result_ui, details_ui, code)` | A tab with one primary button, laid out with the page skeleton: still needed, settings summary, run (progress bar), status box, notification, scroll to status box, 【要重新執行】 (“Needs re-run”), key results and details, “How to do it in R” | `result`, `status`, `state`, `run(...)` |

Not a Shiny module: call it inside the tab’s own
[`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html), so
the settings inputs stay in the tab’s namespace.

### Value objects (put directly into a page or `renderUI()`)

| Function | class | What it does |
|----|----|----|
| [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md), [`kit_done_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_done_status.md), [`kit_error_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_error_status.md), [`kit_stale_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_stale_status.md) | `kit_status` | Status box: 【完成】 (“Done”), 【完成，但請注意】 (“Done, but note”), 【停下來】 (“Stopped”), 【要重新執行】 (“Needs re-run”) |
| [`kit_check()`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md), [`kit_checklist()`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md) | `kit_check`, `kit_checklist` | Checklist (! needs a decision, ✓ OK, i reminder) |
| [`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md) | `kit_code` | One version of the code (at most 70 columns per line, with a “複製” (“Copy”) button) |

Contents are checked at construction (for example, the state can only be
idle/success/warning/error/stale); all have
[`htmltools::as.tags()`](https://rstudio.github.io/htmltools/reference/as.tags.html),
[`format()`](https://rdrr.io/r/base/format.html), and
[`print()`](https://rdrr.io/r/base/print.html).

### Navigation (low level)

| Function | What it does |
|----|----|
| [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md), [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroup.md) | Grouped, unnumbered tab bar (use with `tabsetPanel(type = "hidden")`) |
| [`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/reference/kit_flow_tabs.md) | Ordered flow tabs (① ② ③); tabs that are not a flow step go on the far right |
| [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md) | Computes tab ✓, gray, and needs re-run from status box states |
| [`kit_watch_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_watch_tab_states.md), [`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_send_tab_states.md) | Sends tab states to the browser |

### Page components

| Function | What it does |
|----|----|
| [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md), [`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md) | What this page does (collapsed by default, “看步驟 ▸” (“See steps ▸”)) |
| [`kit_diagram()`](https://jiewentsai.github.io/kitDesign/reference/kit_diagram.md), [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_dg_table.md) | Diagram: small table before processing → small table after |
| [`kit_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_button.md), [`kit_btn_class()`](https://jiewentsai.github.io/kitDesign/reference/kit_btn_class.md) | Primary, secondary, and danger buttons |
| [`kit_callout()`](https://jiewentsai.github.io/kitDesign/reference/kit_callout.md) | Callout (info/caution) |
| [`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md), [`kit_cloud_footer()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_footer.md), [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_cloud.md) | Cloud version: reminder banner below the header, usage notes in the footer, whether this is the cloud version |
| [`kit_download_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_download_button.md) | Download button: Chinese file names save correctly in every browser (test with [`kit_test_download()`](https://jiewentsai.github.io/kitDesign/reference/kit_test_download.md)) |
| [`kit_advanced()`](https://jiewentsai.github.io/kitDesign/reference/kit_advanced.md) | Advanced settings (collapsed) |
| [`kit_settings_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_settings_line.md) | Settings summary (“本次：…” (“This run: …”)) |
| [`kit_ready_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_ready_line.md) | Still needed: … |
| [`kit_next_step()`](https://jiewentsai.github.io/kitDesign/reference/kit_next_step.md), [`kit_app_link()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_link.md) | Next step, link to another app |
| [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md), [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md), [`kit_step_body()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_body.md) | Step card (current, done, not available yet) |
| [`kit_problems()`](https://jiewentsai.github.io/kitDesign/reference/kit_problems.md) | A single problem inside a step card (“還差：…” (“Still needed: …”)) |
| [`kit_scope_bar()`](https://jiewentsai.github.io/kitDesign/reference/kit_scope_bar.md) | Scope bar: an app-wide choice (for example which item bank) right under the tab bar: radio buttons, a hint line, small buttons, an area to confirm |

### Results

| Function | What it does |
|----|----|
| [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md) | Low-level status box rendering (at most 3 points, the rest as “還有 N 點” (“N more”); what to do; raw message) |
| [`kit_details_row()`](https://jiewentsai.github.io/kitDesign/reference/kit_details_row.md), [`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md) | A row of collapsed details below the results |
| [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md), [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md), [`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md) | Low-level functions for “How to do it in R” |
| [`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md), [`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_cols.md) | Wraps code to at most 70 columns per line; columns per line (a Chinese character counts as 2) |
| [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md), [`kit_preview_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_preview_table.md), [`kit_table_scroll()`](https://jiewentsai.github.io/kitDesign/reference/kit_table_scroll.md) | Data table, preview table, horizontally scrolling box |
| [`kit_dt()`](https://jiewentsai.github.io/kitDesign/reference/kit_dt.md) | Interactive table (DT) with the same look, for tables people search, page through and click; selected rows are light lime, text in Chinese (DT is in Suggests) |
| [`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/reference/kit_rows_note.md), [`kit_dims()`](https://jiewentsai.github.io/kitDesign/reference/kit_dims.md), [`kit_num()`](https://jiewentsai.github.io/kitDesign/reference/kit_num.md) | “共 3,418 列 × 25 欄，以下前 10 列。” (“3,418 rows × 25 columns; first 10 rows below.”), thousands separators |
| [`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md), [`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md) | Chart categorical colors (Okabe–Ito) and neutral colors |
| [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md) | Color scale for continuous values (very light lime → light lime → KIT green; 0% stays distinct from blank no-data cells), for heatmaps |
| [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md) | Applies the KIT look to plotly charts: fonts, axis lines, gridlines, white background, left-aligned bold title, legend, color scale, hover boxes, a trimmed toolbar (plotly is in Suggests) |
| [`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_fonts.md) | Attaches the app’s fonts to plotly charts (for downloaded single-file HTML; [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md) attaches them by default) |

### Server side

| Function | What it does |
|----|----|
| [`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md), [`kit_need_files()`](https://jiewentsai.github.io/kitDesign/reference/kit_need_files.md) | Disables the primary button while it can’t be clicked yet and writes what’s still needed above it (low-level version of the module) |
| [`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md) | Scrolls the status box to the top of the screen after a run |
| [`kit_open_details()`](https://jiewentsai.github.io/kitDesign/reference/kit_open_details.md) | Opens a collapsible section |
| [`kit_unload_guard()`](https://jiewentsai.github.io/kitDesign/reference/kit_unload_guard.md) | When there are results, asks once before leaving the page |
| [`kit_notify()`](https://jiewentsai.github.io/kitDesign/reference/kit_notify.md) | Notifications (stopped: red for 10 seconds; others 6 seconds) |
| [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md), [`kit_is_user_error()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_user_error.md) | Plain-language errors shown to users |

## Design language

[`brand/en/design-language.md`](https://github.com/jiewenTsai/kitDesign/blob/main/brand/en/design-language.md)
is the spec for every component (purpose, look, rules, don’ts);
[`brand/_brand.yml`](https://github.com/jiewenTsai/kitDesign/blob/main/brand/_brand.yml)
holds the design variables such as colors and fonts;
[`brand/logo/`](https://github.com/jiewenTsai/kitDesign/tree/main/brand/logo)
holds the logo files.

## Versions and maintenance

- Semantic versioning: patch = fixes, screens and functions unchanged;
  minor = new components or options; major = renames, removals, visible
  design changes. Release steps and checklist:
  [`brand/en/release.md`](https://github.com/jiewenTsai/kitDesign/blob/main/brand/en/release.md);
  changes in each version:
  [`NEWS.md`](https://jiewentsai.github.io/kitDesign/news/index.md).
- To pin an app to a version: `Remotes: jiewenTsai/kitDesign@vX.Y.Z`,
  `Imports: kitDesign (>= X.Y.Z)`.
- The header’s version line lists the main packages, then the date:
  `kit_page(..., package = "kitJoin")` → “kitJoin v0.7.5 · 2026-11-02”;
  kitsUI adds kits (`meta_extra = "kits v0.25.2"`) → “kitsUI v0.8.3 ·
  kits v0.25.2 · 2026-11-02”. kitDesign is the template and is usually
  not listed.
- Name mapping for moving kitJoin and kitsUI to kitDesign:
  [`brand/en/migration.md`](https://github.com/jiewenTsai/kitDesign/blob/main/brand/en/migration.md).

## Development

- R code must be ASCII only (an `R CMD check` rule). Write strings in
  Chinese directly; after editing, run
  `LC_ALL=en_US.UTF-8 Rscript tools/escape_non_ascii.R` from the package
  root: Chinese is replaced with `\uXXXX`, with a “# 原文：…” (“#
  Original: …”) comment added above.
- Styles live in `inst/www/`: `kit-base.css` → `kit-brite.css` →
  `kit-design.css` (the order must not change); scripts are in
  `inst/www/kit.js`.
- Checks:
  `LC_ALL=en_US.UTF-8 R CMD build . && LC_ALL=en_US.UTF-8 R CMD check --no-manual kitDesign_0.4.0.tar.gz`;
  screens: `LC_ALL=en_US.UTF-8 Rscript tools/check_gallery.R`
  (screenshots at 1280 and 390 width; the page must not scroll
  horizontally; danger buttons are salmon); demo brand:
  `Rscript tools/check_gallery.R <folder> 7551 demo`.
- GitHub Actions: `.github/workflows/R-CMD-check.yaml` (push and pull
  request); `.github/workflows/pkgdown.yaml` (website, deployed to the
  `gh-pages` branch).
- Website:
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
  builds into `docs/` (not tracked in git); configuration is in
  `_pkgdown.yml` and `pkgdown/extra.css`, and site-only articles are in
  `vignettes/articles/` (not packaged as vignettes).

## License

MIT © KIT
