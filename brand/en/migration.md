# Migration guide: kitJoin, kitsUI → kitDesign

English | [繁體中文](../遷移對照.md)

When kitJoin 0.5.0 and kitsUI 0.4.0 switch to kitDesign 0.1.0, use these tables to replace the old names with the new ones.
kitDesign **does not export aliases for the old names**: after the switch, the app should no longer define any of these functions.

Steps (once per app):

1. In DESCRIPTION, add `Imports: kitDesign (>= 0.1.0)` and `Remotes: jiewenTsai/kitDesign@v0.1.0`.
2. Rename following the tables below (mostly one-to-one replacements); check the "Argument differences" column separately.
3. Delete the app's `R/kit_brite.R`, the style functions in `R/kit_theme.R`, `R/code_wrap.R`, and the functions marked "removed" in the tables.
4. Build pages with `kit_page()` (`tags$head(tags$style(kit_css()))`, `kit_app_js()`, `kit_tabs_js()`, and `kit_js()` are no longer needed).
5. Run the app's own tests; take screenshots the same way as `tools/check_gallery.R` and compare with the screens from before the change.
6. Regenerate `manifest.json`.

## kitsUI: names that changed

| kitsUI 0.4.0 | kitDesign 0.1.0 | Argument differences |
|---|---|---|
| `mod_guide(goal, steps, output, note)` | `kit_tab_guide(goal, steps, output, technical = NULL, note = NULL, diagram = NULL)` | `steps` can still be a character vector (same as before); `note` must be named |
| `ui_status(kind, line, ..., points)` | `kit_status_ui(kit_status(state, message, points = ))`, or pass a `kit_status()` object directly | `kind` values done/warn/stop/stale are still accepted (mapped to success/warning/error/stale); `...` goes into `kit_status_ui(st, ...)`; the class for "還有 N 點" ("N more points") changes from `kit-status-notes` to `kit-status-more` (see "Visible differences" below) |
| `ui_status_points(points)` | Built into `kit_status_ui()` | Removed |
| `ui_raw_text(raw, title)` | `kit_status(details = raw, details_title = title)` | The raw text becomes a field of the status box |
| `ui_button(id, label, kind)` | `kit_button(id, label, kind)` | Same |
| `ui_callout(..., warning = TRUE)` | `kit_callout(..., warn = TRUE)` | `warning` → `warn`; class changes from `kit-callout-warning` to `kit-callout-warn` (both classes have the same style) |
| `ui_warn_list(head, items)` | `kit_callout(strong(head), tags$ul(...), warn = TRUE)` | Removed (it was only a combination) |
| `ui_next_step(text, button_id, label, kind)` | `kit_next_step(text, button_id, label, kind = "primary")` | Same; the hint changes from `<p class="kit-hint">` to `<div class="kit-hint">` |
| `ui_advanced(..., title, open)` | `kit_advanced(..., title, open, id = NULL)` | Same |
| `ui_details_row(...)` | `kit_details_row(...)` | Same |
| `ui_detail(title, ..., open)` | `kit_detail(title, ..., open)` | Same |
| `ui_settings_line(text)` | `kit_settings_line(text, prefix = NULL)` | Add `prefix = NULL` (kitJoin's default prefix is "本次：" ("This run:")) |
| `ui_code_panel(id, title)` + `render_code_panel(session, id, code)` | `kit_code_panel_ui(id, title)` + `kit_code_panel_server(id, code)` (module); or `kit_code_panel(output_id)` + `kit_render_code_panel(code)` | Code no longer uses `verbatimTextOutput()`; it uses `kit_code()`. Version names use a named list: `list("kits 版" = code)` |
| `ui_code_block(id, label)` | `kit_code(code, label)` | Removed |
| `KIT_CODE_LABEL`, `KIT_CODE_EMPTY` | `kit_code(label = "kits 版")`, `kit_render_code_panel(empty = )` | Removed |
| `kit_tabs_js()` + `kit_tab_state` message + `kit_tab_message()` | `kit_step_tabs_ui()`/`kit_step_tabs_server()` (module); or `kit_flow_tabs()` + `kit_tab_states()` + `kit_watch_tab_states()` | States use one shared set of names: done/locked/stale/ready; the reason (`why`) is now called `tip` |
| `kit_tab_states(data_ok, items, link_done, score)` | Stays in kitsUI (the app's own rules), then passed to `kit_tab_states(states, locked, locked_tips, tabset)` | Now returns the state of each tab |
| CSS for `#tabs a[data-value='manual']` (`kit_css()`) | `kit_flow_tabs(..., aside = "manual")` | CSS removed |
| `kit_js()` (`kit_unload_guard` message) | `kit_unload_guard(on)` | Message renamed to `kit-unload-guard` |
| `KIT_CHART_COLORS`, `KIT_CHART_NEUTRAL`, `kit_chart_colors(n)` | `kit_chart_colors(n)`, `kit_chart_neutral()` | Same |
| `kit_chart_role()`, `kit_chart_categorical()`, `kit_chart_zh()` | Stay in kitsUI | Specific to kits and plotly |
| "kits 0.25.0" in the `kit_header()` version line | `kit_page(meta_extra = paste("kits", packageVersion("kits")))` | |
| `kit_app_description()` (only looks for kitsUI) | `kit_app_description("kitsUI")` | Pass the package name |

## kitJoin: names that changed

| kitJoin 0.5.0 | kitDesign 0.1.0 | Argument differences |
|---|---|---|
| `make_status_ui(st)` | `kit_status_ui(st)`, or pass a `kit_status()` object directly | Same |
| `format_dims(nrow, ncol, preview_cols)` | `kit_dims(nrow, ncol, preview_cols)` | Same |
| `kitsdata_check(state, title, text, actions)` | `kit_check(state, title, why, actions)` | `text` → `why` |
| `tags$ul(class = "kit-checklist", ...)` | `kit_checklist(...)` | |
| Step card `head_ui()` (mod_kitsdata.R) | `kit_step_head()`; for the whole set, `kit_stepcards_ui()`/`kit_stepcards_server()` | |
| `tags$div(class = "kit-problems", ...)` | `kit_problems(..., head = "還差：")` | |
| `kit_navgroups(tabset, selected)` + `KIT_TAB_GROUPS` | `kit_navgroups(groups, tabset, selected)` + `kit_navgroup()`; or the module `kit_step_tabs_ui(..., groups = )` | Groups become an argument |
| `kit_tab_states(n_files, states, tabset)` | Stays in kitJoin (the rules belong to the app), then passed to `kit_tab_states(status, locked, locked_tips, tabset)` | |
| `kit_run_gate(session, output, missing, link, button_id)` | Same; or the module `kit_run_gate_ui()`/`kit_run_gate_server()` | Adds `output_id` |
| `kit_code_blocks(snips)` | `kit_code_blocks(snips, note = )` | The default note is now the generic sentence; pass kitJoin's original note with `note = ` |
| `kit_abort_class(class, ..., data)` | `kit_abort(..., class = , data = )` | Argument order differs |
| `kit_app_meta()` (reads DESCRIPTION) | `kit_app_meta(version, date, extra, show_kitdesign)` | Version must be passed in |
| `kit_header(title, subtitle, tagline, meta)` | `kit_header(title, subtitle, tagline, version, date, meta_extra, logo, show_kitdesign)` | `meta` → `version`, `date` |
| `kit_kitsui_link()`, `kit_kitsui_button()` | Stay in kitJoin; the links inside can use `kit_app_link()` | |
| `KIT_BTN[["secondary"]]` | `kit_btn_class("secondary")` | |
| `kit_css()`, `kit_css_guide()`, `kit_css_brite()`, `kit_app_js()` | `use_kit()` (already included by `kit_page()`) | Removed |
| `kit_code_cols()`, `kit_code_wrap()` (code_wrap.R) | Same (moved over from kitJoin) | Delete the app's copy |

## kitDesign 0.4.0: downloads and the cloud version move into kitDesign

kitJoin 0.6.0 and kitsUI 0.5.0 switch to `Imports: kitDesign (>= 0.4.0)`; delete `R/download.R` from both apps,
and keep only the text in `R/cloud.R`.

| In the app | kitDesign 0.4.0 | Argument differences |
|---|---|---|
| `kit_download_button(session, id, label, filename, content, class)` | `kit_download_button(..., app = )` | Adds `app` (default `getOption("kitDesign.app", "kit")`); the app sets `options(kitDesign.app = "kitJoin")` in `.onLoad()` |
| `kit_download_type()` | Internal | Uses the kitsUI version: `.csv`, `.zip`, `.html` have their own MIME types; everything else (`.sav`, `.csv.gz`) is octet-stream |
| `kit_ascii_filename()`, `kit_content_disposition()`, `kit_download_ext()`, `kit_percent_encode()`, `kit_register_download()`, `kit_download_filter()`… | Internal | "kitjoin" and "kitsui" in fallback file names become `tolower(app)` |
| `kit_test_download(session, id)` in tests (helper-download.R) | `kit_test_download(session, id, write = TRUE)` | Also returns `filename`; `write = FALSE` checks only the file name |
| `kit_is_cloud()` | `kit_is_cloud()` | Same |
| `kit_cloud_footer()` (text written inside the function) | `kit_cloud_footer(sections, links, title, id)` | The text becomes arguments: `sections` is "section name = body", `links` is "link text = URL"; the apps keep `kitjoin_cloud_footer()` and `kitsui_cloud_footer()` |

The skeleton repeated in every kitJoin tab is replaced by `kit_run_tab_ui()`/`kit_run_tab_server()`:

| In a kitJoin tab | `kit_run_tab_*` |
|---|---|
| `uiOutput(ns("settings_line"))`, `uiOutput(ns("ready"))`, `kit_button(ns("run"), …, disabled = TRUE)`, `uiOutput(ns("status"))`, `kit_download_ui(ns)`, `kit_details_row(uiOutput(ns("result_details")), kit_code_panel(ns("code")))` | `kit_run_tab_ui(id, run_label, guide, ..., result, downloads, details, code, next_step)` |
| `kit_run_gate(session, output, missing, link)` | `ready = `, `ready_link = ` |
| `output$settings_line <- renderUI(kit_settings_line(c(…)))` | `settings = function() c(…)` |
| `observeEvent(list(…), { if (!is.null(result())) { result(NULL); status(kit_stale_status(…)) } })` | `stale_on = function() list(…)` |
| `observeEvent(input$run, { result(NULL); st <- tryCatch(withProgress(…), error = …); status(st); kit_notify(st); kit_scroll_to("status") })` | `run = `, `done = `, `error = `, `progress = ` (checks before the button is pressed: `guard = `; errors that need confirmation: `confirm = `) |
| `output$status <- renderUI(kit_status_ui(status()))` | Built in |
| `if (is.null(res)) return(NULL)` in `output$result` and `output$result_details` | `result_ui = function(res)`, `details_ui = function(res)` |
| `output$code <- renderUI(kit_code_blocks(…, note = ))` | `code = function() …`, `code_note = ` |
| `list(state = reactive(status()$state))` | `list(state = tab$state)` |

Each app's own download area (kitJoin's `kit_download_server()`: three buttons for CSV, CSV.GZ, and SAV plus the SPSS renaming reminder;
kitsUI's `download_csv_ui()` and `download_plot_ui()`: CSV via readr, and plot files that need pandoc) stays in the app:
the file formats belong to the app.

## Same names: use kitDesign's directly

`kit_theme`, `kit_colors`, `kit_logo_uri`, `kit_tab_guide`, `kit_button`, `kit_callout`, `kit_advanced`,
`kit_details_row`, `kit_detail`, `kit_settings_line`, `kit_next_step`, `kit_rows_note`, `kit_steps`, `kit_num`,
`kit_status`, `kit_done_status`, `kit_error_status`, `kit_stale_status`, `kit_notify`, `kit_ready_line`,
`kit_need_files`, `kit_static_table`, `kit_preview_table`, `kit_code_panel`, `kit_scroll_to`, `kit_dg_table`,
`kit_diagram`, `kit_watch_tab_states`, `kit_abort`, `kit_cloud_banner` (its content is now arguments).

## What stays in the apps (not moved)

- kits, IRT, and file reading/writing: `read_data_file`, SAV/CSV reading and writing, `kitsui_*`, `kits_*`, `check_table`, `kit_table` (kitsUI's count-column rules)…
- Download areas: kitJoin's `kit_download_server()` and `kit_download_ui()`, kitsUI's `download_*_ui` and `render_download_*` (the file formats belong to the app; the button itself is kitDesign's `kit_download_button()`).
- The user manual and pandoc: `kit_manual_ui`, `kit_pandoc_*`, `kit_setup_pandoc`.
- Links between the two apps: `kit_kitsui_link`, `ui_kitjoin_button`, `ui_kitjoin_hint`, `KITSUI_URL`, `KITJOIN_URL`.
- Cloud version text: the one-line banner and each section of the usage notes (`kitjoin_cloud_footer()`, `kitsui_cloud_footer()`).
- Other app-specific items: `kit_source_note_ui`, `kit_upload_todo`, `join_method_example`, `kit_max_upload_mb`, `ui_go_items`.

## Visible differences (compare screenshots after migrating)

- Danger button (`kind = "danger"`): since kitDesign 0.2.0 it is salmon (`nb-salmon`) with black text, following the design language; both apps used Bootstrap red before.
- The hidden "（已完成）" ("(done)") on tabs: placed inside the tab bar (the tab bar and tabs are the positioning reference), so it does not stretch the page on phones.
- kitJoin's item table style (`.kit-itemtable`) moves into kitDesign; apps no longer need their own CSS for it.
- kitsUI's "還有 N 點" ("N more points"): was `details.kit-status-notes` (one size smaller), now kitJoin's `details.kit-status-more` (same size as the other points).
- kitsUI's flow tabs gain a hidden "（已完成）" ("(done)") when complete; the visible ✓ is unchanged.
- kitsUI's "用 R 怎麼做" ("How to do it in R"): code switches from `verbatimTextOutput()` to `kit_code()` (same box; long lines wrap automatically).
- "複製" ("Copy") button: `onclick` is now handled by `kit.js` (`.kit-copy`); it looks the same.
