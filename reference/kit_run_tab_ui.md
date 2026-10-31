# Run tab

Page skeleton for a tab with one primary button. `kit_run_tab_ui()` lays
out the fixed parts following the page skeleton; the tab's own settings
go in `...`. `kit_run_tab_server()` is called inside the tab's
[`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html) and
handles the status flow:

## Usage

``` r
kit_run_tab_ui(
  id,
  run_label,
  guide = NULL,
  ...,
  gate = TRUE,
  result = FALSE,
  downloads = TRUE,
  details = TRUE,
  code = TRUE,
  next_step = FALSE
)

kit_run_tab_server(
  input,
  output,
  session,
  run_label,
  run,
  done = NULL,
  ready = NULL,
  ready_link = function() NULL,
  settings = NULL,
  stale_on = NULL,
  progress = NULL,
  error = function(e) kit_error_status(e, run_label),
  guard = NULL,
  confirm = list(),
  result_ui = NULL,
  details_ui = NULL,
  code = NULL,
  code_note = KIT_CODE_NOTE
)
```

## Arguments

- id:

  The tab (module) id.

- run_label:

  The primary button's text (start with a verb, for example "執行串接",
  "Run join").

- guide:

  The "what this page does" at the top
  ([`kit_tab_guide()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_guide.md)).

- ...:

  The tab's own settings (inputs, hints), placed above the settings
  summary.

- gate:

  `TRUE`: the primary button starts disabled, with the "還差" ("Still
  needed") line above it; `FALSE`: always clickable (no `ready`).

- result, downloads, next_step:

  The key results below the status box, the download area, and the next
  step at the very bottom: `TRUE` is a
  [`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) (ids
  `result`, `downloads`, `next_step`); you can also pass a tag directly;
  `FALSE` leaves it out.

- details:

  Details row: `TRUE` adds `uiOutput("result_details")` (preview and
  checks of the result); when both `details` and `code` are `FALSE`,
  there is no details row.

- code:

  UI (`kit_run_tab_ui()`): `TRUE` adds "用 R 怎麼做" ("How to do it in
  R")
  ([`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md),
  output `code`). Server (`kit_run_tab_server()`): a function that
  returns the code (the `code` of
  [`kit_render_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_render_code_panel.md));
  with `NULL`, the tab renders it itself.

- input, output, session:

  The input, output, and session of the tab's
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

- run:

  The function that runs: returns the result (any object), or a
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md)
  (no result; for example, a problem must be handled first). To stop,
  call
  [`kit_abort()`](https://jiewentsai.github.io/kitDesign/reference/kit_abort.md)
  (with a plain-language reason).

- done:

  `function(result)`: the status after running
  ([`kit_done_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_done_status.md));
  the result is already saved before it is called.

- ready:

  A reactive: what is still needed (character vector; length 0 = ready
  to run); with `NULL`, there is no "還差" line (`gate = FALSE`).

- ready_link:

  A function: the link after "還差" (a tag or `NULL`).

- settings:

  A function: the parts of the settings summary (character vector;
  `NULL` shows nothing); with `NULL`, there is no settings summary.

- stale_on:

  A function: things whose change makes the result out of date (for
  example `list(input$method, data())`); with `NULL`, the tab handles
  this itself (using the returned `result` and `status`).

- progress:

  The progress bar message ("正在串接資料…", "Joining data…"); with
  `NULL`, there is no progress bar.

- error:

  `function(e)`: the status on error; defaults to
  `kit_error_status(e, run_label)`.

- guard:

  A function: a check before running; when it returns a
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md),
  nothing runs (status box and notification, no scrolling); `NULL` skips
  the check.

- confirm:

  Errors the user must confirm: a named list; names are condition
  classes, values are `function(e)`. It opens a confirmation dialog and
  returns a status (no notification, no scrolling; the dialog is the
  response). After confirming, run again with the returned `run(...)`.

- result_ui:

  `function(result)`: the key results below the status box (output
  `result`); with `NULL`, the tab renders it itself.

- details_ui:

  `function(result)`: the first cell of the details row (output
  `result_details`, for example
  [`kit_detail()`](https://jiewentsai.github.io/kitDesign/reference/kit_detail.md)
  "結果預覽", "Result preview"); with `NULL`, the tab renders it itself.

- code_note:

  The one-line note at the top of "用 R 怎麼做".

## Value

`kit_run_tab_ui()`: a
[`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html).

`kit_run_tab_server()`: a list,

- `result`: a `reactiveVal`, the result of this run (`NULL` when there
  is none yet or it is out of date);

- `status`: a `reactiveVal`, the status box's
  [`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md);

- `state`: a reactive, the status box's state (used for the ✓ on step
  tabs,
  [`kit_tab_states()`](https://jiewentsai.github.io/kitDesign/reference/kit_tab_states.md));

- `run(...)`: runs once, just like pressing the primary button (`...`
  goes to `run()`; for example "仍要執行", "Run anyway", in a
  confirmation dialog).

## Details

- Primary button: disabled while something is still needed (`ready()` is
  not empty), with a "還差：…" ("Still needed: …") line above it
  ([`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md)).

- Settings summary: the parts of `settings()` joined into one line
  ([`kit_settings_line()`](https://jiewentsai.github.io/kitDesign/reference/kit_settings_line.md)).

- Pressing the primary button: clear the old result → `guard()` →
  `run()` inside a progress bar → save the result, `done(result)` is the
  status; on error, `error(e)` is the status → status box, notification
  ([`kit_notify()`](https://jiewentsai.github.io/kitDesign/reference/kit_notify.md)),
  scroll to the status box
  ([`kit_scroll_to()`](https://jiewentsai.github.io/kitDesign/reference/kit_scroll_to.md)).

- When settings or data change (`stale_on()` changes) and there is a
  result: the result is cleared and the status is 【要重新執行】 ("Run
  again").

- Key results, the first cell of the details row, and "How to do it in
  R": rendered only when there is a result.

Fixed output ids (without namespace): `settings_line`, `ready`, `run`
(the button), `status`, `result`, `downloads`, `result_details`, `code`,
`next_step`.

## See also

[`kit_run_gate()`](https://jiewentsai.github.io/kitDesign/reference/kit_run_gate.md),
[`kit_status()`](https://jiewentsai.github.io/kitDesign/reference/kit_status.md),
[`kit_code_panel()`](https://jiewentsai.github.io/kitDesign/reference/kit_code_panel.md)

## Examples

``` r
if (interactive()) {
  mod_stack_ui <- function(id) {
    kit_run_tab_ui(
      id, "執行疊加",
      guide = kit_tab_guide("把各波資料上下疊起來。", c("按「執行疊加」", "看狀態框與預覽"), "一張長格式的資料。"),
      shiny::numericInput(shiny::NS(id, "n"), "幾個波次", 2),
      downloads = FALSE
    )
  }
  mod_stack_server <- function(id) {
    shiny::moduleServer(id, function(input, output, session) {
      tab <- kit_run_tab_server(
        input, output, session, "執行疊加",
        ready = shiny::reactive(if (input$n < 2) "至少 2 個波次"),
        settings = function() paste0(input$n, " 個波次"),
        stale_on = function() input$n,
        progress = "正在疊加資料…",
        run = function() data.frame(wave = seq_len(input$n)),
        done = function(res) kit_done_status(paste0("疊加完成：", nrow(res), " 列。")),
        details_ui = function(res) kit_detail("結果預覽", kit_static_table(res)),
        code = function() "stacked <- dplyr::bind_rows(t1, t2, .id = \"wave\")"
      )
      list(state = tab$state)
    })
  }
  shiny::shinyApp(kit_page("KIT 示範", NULL, mod_stack_ui("stack")),
                  function(input, output, session) mod_stack_server("stack"))
}
```
