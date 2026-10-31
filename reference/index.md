# Package index

## Setup and page

Once per app: theme, styles, header, versions.

- [`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md)
  : A KIT page: theme, styles, and header set up in one call
- [`kit_theme()`](https://jiewentsai.github.io/kitDesign/reference/kit_theme.md)
  : KIT's bslib theme
- [`use_kit()`](https://jiewentsai.github.io/kitDesign/reference/use_kit.md)
  : KIT styles and browser-side scripts (an htmltools dependency)
- [`kit_header()`](https://jiewentsai.github.io/kitDesign/reference/kit_header.md)
  : KIT header
- [`kit_app_meta()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_meta.md)
  : The version line in the header, e.g. "v0.5.0 · 2026-10-31"
- [`kit_app_description()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_description.md)
  : Read the app's version and date (Version and Date in DESCRIPTION)
- [`kit_versions()`](https://jiewentsai.github.io/kitDesign/reference/kit_versions.md)
  : Versions: kitDesign and the app's own
- [`kit_logo_uri()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_uri.md)
  : KIT logo (data URI)
- [`kit_logo_file()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_file.md)
  : URL of a logo file (for use on the page)
- [`kit_logo_dependency()`](https://jiewentsai.github.io/kitDesign/reference/kit_logo_dependency.md)
  : htmlDependency for the logo files (inst/logo/): the header SVG and
  tab icon are fetched by URL
- [`kit_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_colors.md)
  : KIT brand color constants (for custom CSS or charts)
- [`kit_new_app()`](https://jiewentsai.github.io/kitDesign/reference/kit_new_app.md)
  : Start a new KIT Shiny app
- [`kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md)
  : Component gallery app

## Brand

Switch to another project’s logo and colors.

- [`kit_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md)
  : Brand: logo and colors

- [`kit_current_brand()`](https://jiewentsai.github.io/kitDesign/reference/kit_current_brand.md)
  :

  The current brand: `options(kitDesign.brand = )`, KIT when not set

## Step tabs (NavTabs)

- [`kit_step_tabs_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  [`kit_step_tabs_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  : Step tabs module

- [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md)
  : Grouped tab bar (unnumbered; the kitJoin style)

- [`kit_navgroup()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroup.md)
  :

  One group in the tab bar (for
  [`kit_navgroups()`](https://jiewentsai.github.io/kitDesign/reference/kit_navgroups.md))

- [`kit_flow_tabs()`](https://jiewentsai.github.io/kitDesign/reference/kit_flow_tabs.md)
  : Ordered workflow tabs (the kitsUI style)

- [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md)
  : State of each tab

- [`kit_watch_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_watch_tab_states.md)
  : Send tab states to the browser whenever they change

- [`kit_send_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_send_tab_states.md)
  : Send tab states to the browser

## Page guide (PageGuide)

- [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md)
  : Page guide: what this page does

- [`kit_steps()`](https://jiewentsai.github.io/kitDesign/reference/kit_steps.md)
  :

  Numbered list of steps (for the `steps` of
  [`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md))

## Status box (StatusBox)

- [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  [`as.tags(`*`<kit_status>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  [`format(`*`<kit_status>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  [`print(`*`<kit_status>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  : Status object (status box)

- [`kit_done_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_done_status.md)
  : Status after a run: 【完成，但請注意】 (done, but take note) when
  something needs attention, otherwise 【完成】 (done)

- [`kit_error_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_error_status.md)
  : Status for a failed run (【停下來】, stopped)

- [`kit_stale_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_stale_status.md)
  : Old result no longer valid after files or settings change
  (【要重新執行】, "Run again")

- [`kit_status_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_status_ui.md)
  : Status box

- [`kit_notify()`](https://jiewentsai.github.io/kitDesign/reference/kit_notify.md)
  : Show a notification (Shiny's showNotification)

- [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
  : An error meant for the user

- [`kit_is_user_error()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_user_error.md)
  :

  Was the error thrown by
  [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)?

## Button

- [`kit_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_button.md)
  : Button
- [`kit_btn_class()`](https://jiewentsai.github.io/kitDesign/reference/kit_btn_class.md)
  : Class for a button kind

## Download button (DownloadButton)

- [`kit_download_button()`](https://jiewentsai.github.io/kitDesign/reference/kit_download_button.md)
  : Download button
- [`kit_test_download()`](https://jiewentsai.github.io/kitDesign/reference/kit_test_download.md)
  : Press a download button in tests

## File helpers

Encoding, SPSS variable names, compressed file paths, opening the
browser.

- [`kit_fix_utf8_chr()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_fix_utf8_df()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_is_valid_utf8_df()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_sav_safe_names()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_truncate_bytes()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_gz_path()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  [`kit_open_browser()`](https://jiewentsai.github.io/kitDesign/reference/kit_files.md)
  : File helpers: encoding, SPSS variable names, compressed file paths,
  opening the browser

## Callout

- [`kit_callout()`](https://jiewentsai.github.io/kitDesign/reference/kit_callout.md)
  : Callout
- [`kit_cloud_banner()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_banner.md)
  : Cloud version reminder banner (one line below the header)
- [`kit_cloud_footer()`](https://jiewentsai.github.io/kitDesign/reference/kit_cloud_footer.md)
  : Cloud version usage notes (bottom of the page, small gray text)
- [`kit_is_cloud()`](https://jiewentsai.github.io/kitDesign/reference/kit_is_cloud.md)
  : Is this the cloud version?

## Data table (DataTable)

- [`kit_static_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_static_table.md)
  : Small table (put directly inside renderUI(); no separate output
  needed)

- [`kit_preview_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_preview_table.md)
  :

  Data for a preview table (pass to
  [`shiny::renderTable()`](https://rdrr.io/pkg/shiny/man/renderTable.html))

- [`kit_rows_note()`](https://jiewentsai.github.io/kitDesign/reference/kit_rows_note.md)
  : Note for a long table: "共 3,418 列 × 25 欄，以下前 10 列、前 20
  欄。" ("3,418 rows × 25 columns in total; first 10 rows and 20 columns
  below.")

- [`kit_table_scroll()`](https://jiewentsai.github.io/kitDesign/reference/kit_table_scroll.md)
  : Put wide tables in here: they scroll sideways in their own box and
  do not break the layout

- [`kit_num()`](https://jiewentsai.github.io/kitDesign/reference/kit_num.md)
  : Integer with thousands separators

- [`kit_dims()`](https://jiewentsai.github.io/kitDesign/reference/kit_dims.md)
  : Dimension text: "5 列 × 7 欄" ("5 rows × 7 columns")

## Chart

- [`kit_plotly_style()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_style.md)
  : Give a plotly chart the KIT look (chart)
- [`kit_plotly_fonts()`](https://jiewentsai.github.io/kitDesign/reference/kit_plotly_fonts.md)
  : Attach the app's typeface to a plotly chart (for downloaded HTML)
- [`kit_chart_colors()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_colors.md)
  : Categorical chart colors
- [`kit_chart_neutral()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_neutral.md)
  : Neutral color for non-categorical chart elements
- [`kit_chart_sequential()`](https://jiewentsai.github.io/kitDesign/reference/kit_chart_sequential.md)
  : Color scale for continuous values (chart)

## Details row (Details)

- [`kit_details_row()`](https://jiewentsai.github.io/kitDesign/reference/kit_details_row.md)
  : Details row
- [`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md)
  : One detail: collapsed by default, a one-line small-print title
- [`kit_advanced()`](https://jiewentsai.github.io/kitDesign/reference/kit_advanced.md)
  : Advanced settings: collapsed by default
- [`kit_settings_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_settings_line.md)
  : Settings summary: a line of small text above the primary button or
  the result

## How to do it in R (CodePanel)

- [`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  [`kit_code_panel_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  : "How to do it in R" module (code panel)

- [`kit_code()`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  [`as.tags(`*`<kit_code>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  [`format(`*`<kit_code>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  [`print(`*`<kit_code>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_code.md)
  : Code for one version (code panel)

- [`kit_code_wrap()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_wrap.md)
  : Wrap code to at most 70 columns per line

- [`kit_code_cols()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_cols.md)
  : Display width of each line (CJK and full-width characters count as 2
  columns)

- [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)
  : Placeholder for "How to do it in R" (code panel)

- [`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md)
  :

  Server side: render code into
  [`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)

- [`kit_code_blocks()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_blocks.md)
  : Content of "How to do it in R": a note plus code in one or more
  versions (with "Copy")

## Step card (StepCard)

- [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  [`kit_stepcards_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  : Step card module
- [`kit_step_card()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_card.md)
  : Step card
- [`kit_step_head()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_head.md)
  : Step card header
- [`kit_step_body()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_body.md)
  : Step card content

## Checklist

- [`kit_checklist()`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  [`as.tags(`*`<kit_checklist>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  [`format(`*`<kit_checklist>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  [`print(`*`<kit_checklist>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_checklist.md)
  : Checklist
- [`kit_check()`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  [`as.tags(`*`<kit_check>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  [`format(`*`<kit_check>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  [`print(`*`<kit_check>`*`)`](https://jiewentsai.github.io/kitDesign/reference/kit_check.md)
  : One checklist row
- [`kit_problems()`](https://jiewentsai.github.io/kitDesign/reference/kit_problems.md)
  : Problems in a table or list (dark orange-red text)

## What’s still needed (ReadyLine)

- [`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  [`kit_run_gate_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  : Primary button + "Still needed: …" module (ready line)
- [`kit_ready_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_ready_line.md)
  : Ready line ("what's still needed")
- [`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md)
  : When the primary button cannot be pressed yet: disable it and show
  what is still needed above it
- [`kit_need_files()`](https://jiewentsai.github.io/kitDesign/reference/kit_need_files.md)
  : "還差" ("Still needed"): the sentence shown when there are not
  enough files

## Next step (NextStep)

- [`kit_next_step()`](https://jiewentsai.github.io/kitDesign/reference/kit_next_step.md)
  : Next step
- [`kit_app_link()`](https://jiewentsai.github.io/kitDesign/reference/kit_app_link.md)
  : A link to another website or app (opens in a new tab)

## Diagram

- [`kit_diagram()`](https://jiewentsai.github.io/kitDesign/reference/kit_diagram.md)
  : Diagram: small table before → small table after, with a
  plain-language line below
- [`kit_dg_table()`](https://jiewentsai.github.io/kitDesign/reference/kit_dg_table.md)
  : Small table for diagrams (2–3 columns, 2–4 rows)

## Run tab (RunTab)

The skeleton of a tab with one primary button: page order and status
flow.

- [`kit_run_tab_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_tab_ui.md)
  [`kit_run_tab_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_tab_ui.md)
  : Run tab

## Modules

Stateful components: `*_ui(id)` + `*_server(id)`, one line per page.

- [`kit_step_tabs_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  [`kit_step_tabs_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_step_tabs_ui.md)
  : Step tabs module
- [`kit_stepcards_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  [`kit_stepcards_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_stepcards_ui.md)
  : Step card module
- [`kit_run_gate_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  [`kit_run_gate_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate_ui.md)
  : Primary button + "Still needed: …" module (ready line)
- [`kit_code_panel_ui()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  [`kit_code_panel_server()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel_ui.md)
  : "How to do it in R" module (code panel)

## Page behavior

Scroll to the result, open collapsed sections, warn before leaving.

- [`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md)
  : After running, scroll the status box to the top of the screen
- [`kit_open_details()`](https://jiewentsai.github.io/kitDesign/reference/kit_open_details.md)
  : Open a collapsible section (for example, open the advanced settings
  after applying a preset)
- [`kit_unload_guard()`](https://jiewentsai.github.io/kitDesign/reference/kit_unload_guard.md)
  : Reminder before leaving the page
