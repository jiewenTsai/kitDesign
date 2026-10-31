# 執行分頁（RunTab）：一頁一個主要按鈕的分頁骨架
#
# 頁面骨架（KIT 設計語言）由上到下：這一頁做什麼 → 設定 → 設定摘要 → 還差 → 主要按鈕 → 狀態框 →
# 重點 → 下載 → 細節列（結果的細節、用 R 怎麼做）→ 下一步。狀態流：改了設定 →【要重新執行】；
# 按主要按鈕 → 執行（進度條）→【完成】／【停下來】→ 通知、捲到狀態框。
# kitJoin 的每個分頁都是這個樣子；骨架在這裡，分頁只寫自己的設定、執行與結果。
# 不是 Shiny 模組：設定的 input 留在分頁自己的 namespace 裡（id 不變）。

#' Run tab
#'
#' Page skeleton for a tab with one primary button. `kit_run_tab_ui()` lays out the fixed parts
#' following the page skeleton; the tab's own settings go in `...`. `kit_run_tab_server()` is
#' called inside the tab's `moduleServer()` and handles the status flow:
#'
#' - Primary button: disabled while something is still needed (`ready()` is not empty), with a
#'   "還差：…" ("Still needed: …") line above it ([kit_run_gate()]).
#' - Settings summary: the parts of `settings()` joined into one line ([kit_settings_line()]).
#' - Pressing the primary button: clear the old result → `guard()` → `run()` inside a progress bar
#'   → save the result, `done(result)` is the status; on error, `error(e)` is the status → status
#'   box, notification ([kit_notify()]), scroll to the status box ([kit_scroll_to()]).
#' - When settings or data change (`stale_on()` changes) and there is a result: the result is
#'   cleared and the status is 【要重新執行】 ("Run again").
#' - Key results, the first cell of the details row, and "How to do it in R": rendered only when
#'   there is a result.
#'
#' Fixed output ids (without namespace): `settings_line`, `ready`, `run` (the button), `status`,
#' `result`, `downloads`, `result_details`, `code`, `next_step`.
#'
#' @param id The tab (module) id.
#' @param run_label The primary button's text (start with a verb, for example "執行串接",
#'   "Run join").
#' @param guide The "what this page does" at the top ([kit_tab_guide()]).
#' @param ... The tab's own settings (inputs, hints), placed above the settings summary.
#' @param gate `TRUE`: the primary button starts disabled, with the "還差" ("Still needed") line
#'   above it; `FALSE`: always clickable (no `ready`).
#' @param result,downloads,next_step The key results below the status box, the download area, and
#'   the next step at the very bottom: `TRUE` is a `uiOutput()` (ids `result`, `downloads`,
#'   `next_step`); you can also pass a tag directly; `FALSE` leaves it out.
#' @param details Details row: `TRUE` adds `uiOutput("result_details")` (preview and checks of the
#'   result); when both `details` and `code` are `FALSE`, there is no details row.
#' @param code UI (`kit_run_tab_ui()`): `TRUE` adds "用 R 怎麼做" ("How to do it in R")
#'   ([kit_code_panel()], output `code`).
#'   Server (`kit_run_tab_server()`): a function that returns the code (the `code` of
#'   [kit_render_code_panel()]); with `NULL`, the tab renders it itself.
#' @return `kit_run_tab_ui()`: a `tagList()`.
#'
#'   `kit_run_tab_server()`: a list,
#'   - `result`: a `reactiveVal`, the result of this run (`NULL` when there is none yet or it is
#'     out of date);
#'   - `status`: a `reactiveVal`, the status box's [kit_status()];
#'   - `state`: a reactive, the status box's state (used for the ✓ on step tabs,
#'     [kit_tab_states()]);
#'   - `run(...)`: runs once, just like pressing the primary button (`...` goes to `run()`; for
#'     example "仍要執行", "Run anyway", in a confirmation dialog).
#' @seealso [kit_run_gate()], [kit_status()], [kit_code_panel()]
#' @examples
#' if (interactive()) {
#'   mod_stack_ui <- function(id) {
#'     kit_run_tab_ui(
#'       id, "執行疊加",
#'       guide = kit_tab_guide("把各波資料上下疊起來。", c("按「執行疊加」", "看狀態框與預覽"), "一張長格式的資料。"),
#'       shiny::numericInput(shiny::NS(id, "n"), "幾個波次", 2),
#'       downloads = FALSE
#'     )
#'   }
#'   mod_stack_server <- function(id) {
#'     shiny::moduleServer(id, function(input, output, session) {
#'       tab <- kit_run_tab_server(
#'         input, output, session, "執行疊加",
#'         ready = shiny::reactive(if (input$n < 2) "至少 2 個波次"),
#'         settings = function() paste0(input$n, " 個波次"),
#'         stale_on = function() input$n,
#'         progress = "正在疊加資料…",
#'         run = function() data.frame(wave = seq_len(input$n)),
#'         done = function(res) kit_done_status(paste0("疊加完成：", nrow(res), " 列。")),
#'         details_ui = function(res) kit_detail("結果預覽", kit_static_table(res)),
#'         code = function() "stacked <- dplyr::bind_rows(t1, t2, .id = \"wave\")"
#'       )
#'       list(state = tab$state)
#'     })
#'   }
#'   shiny::shinyApp(kit_page("KIT 示範", NULL, mod_stack_ui("stack")),
#'                   function(input, output, session) mod_stack_server("stack"))
#' }
#' @export
kit_run_tab_ui <- function(id, run_label, guide = NULL, ..., gate = TRUE, result = FALSE,
                           downloads = TRUE, details = TRUE, code = TRUE, next_step = FALSE) {
  ns <- shiny::NS(id)
  slot <- function(x, output_id, ...) {
    if (isTRUE(x)) shiny::uiOutput(ns(output_id), ...) else if (isFALSE(x) || is.null(x)) NULL else x
  }
  shiny::tagList(
    guide,
    ...,
    shiny::uiOutput(ns("settings_line")),
    if (gate) shiny::uiOutput(ns("ready")),
    kit_button(ns("run"), run_label, "primary", disabled = gate),
    shiny::uiOutput(ns("status")),
    slot(result, "result"),
    slot(downloads, "downloads"),
    if (details || code) {
      kit_details_row(
        if (details) shiny::uiOutput(ns("result_details"), inline = TRUE),
        if (code) kit_code_panel(ns("code"))
      )
    },
    slot(next_step, "next_step")
  )
}

#' @rdname kit_run_tab_ui
#' @param input,output,session The input, output, and session of the tab's `moduleServer()`.
#' @param run The function that runs: returns the result (any object), or a [kit_status()] (no
#'   result; for example, a problem must be handled first).
#'   To stop, call [kit_abort()] (with a plain-language reason).
#' @param done `function(result)`: the status after running ([kit_done_status()]); the result is
#'   already saved before it is called.
#' @param ready A reactive: what is still needed (character vector; length 0 = ready to run); with
#'   `NULL`, there is no "還差" line (`gate = FALSE`).
#' @param ready_link A function: the link after "還差" (a tag or `NULL`).
#' @param settings A function: the parts of the settings summary (character vector; `NULL` shows
#'   nothing); with `NULL`, there is no settings summary.
#' @param stale_on A function: things whose change makes the result out of date (for example
#'   `list(input$method, data())`); with `NULL`, the tab handles this itself (using the returned
#'   `result` and `status`).
#' @param progress The progress bar message ("正在串接資料…", "Joining data…"); with `NULL`,
#'   there is no progress bar.
#' @param error `function(e)`: the status on error; defaults to `kit_error_status(e, run_label)`.
#' @param guard A function: a check before running; when it returns a [kit_status()], nothing runs
#'   (status box and notification, no scrolling); `NULL` skips the check.
#' @param confirm Errors the user must confirm: a named list; names are condition classes, values
#'   are `function(e)`. It opens a confirmation dialog and returns a status (no notification, no
#'   scrolling; the dialog is the response). After confirming, run again with the returned
#'   `run(...)`.
#' @param result_ui `function(result)`: the key results below the status box (output `result`);
#'   with `NULL`, the tab renders it itself.
#' @param details_ui `function(result)`: the first cell of the details row (output
#'   `result_details`, for example [kit_detail()] "結果預覽", "Result preview"); with `NULL`, the
#'   tab renders it itself.
#' @param code_note The one-line note at the top of "用 R 怎麼做".
#' @export
kit_run_tab_server <- function(input, output, session, run_label, run, done = NULL,
                               ready = NULL, ready_link = function() NULL, settings = NULL,
                               stale_on = NULL, progress = NULL,
                               error = function(e) kit_error_status(e, run_label),
                               guard = NULL, confirm = list(), result_ui = NULL,
                               details_ui = NULL, code = NULL, code_note = KIT_CODE_NOTE) {
  result <- shiny::reactiveVal(NULL)
  status <- shiny::reactiveVal(kit_status())
  if (!is.null(ready)) kit_run_gate(session, output, ready, link = ready_link)
  if (!is.null(settings)) output$settings_line <- shiny::renderUI(kit_settings_line(settings()))

  # 改了設定或資料：有結果時清掉，【要重新執行】
  if (!is.null(stale_on)) {
    shiny::observeEvent(stale_on(), {
      if (!is.null(result())) {
        result(NULL)
        status(kit_stale_status(run_label))
      }
    }, ignoreInit = TRUE)
  }

  in_progress <- function(expr) {
    if (is.null(progress)) expr else shiny::withProgress(message = progress, value = 0.3, expr)
  }
  run_now <- function(...) {
    result(NULL)
    st <- if (!is.null(guard)) guard()
    if (!is.null(st)) {
      status(st)
      kit_notify(st, session)
      return(invisible(st))
    }
    asked <- FALSE
    st <- tryCatch(
      in_progress({
        out <- run(...)
        if (inherits(out, "kit_status")) out else {
          result(out)
          done(out)
        }
      }),
      error = function(e) {
        cls <- intersect(class(e), names(confirm))
        if (length(cls) == 0) return(error(e))
        asked <<- TRUE
        confirm[[cls[1]]](e)
      }
    )
    status(st)
    if (!asked) {
      kit_notify(st, session)
      kit_scroll_to("status", session)
    }
    invisible(st)
  }
  shiny::observeEvent(input$run, run_now())

  output$status <- shiny::renderUI(kit_status_ui(status()))
  # 有結果時才畫的部分
  when_result <- function(f) {
    shiny::renderUI({
      res <- result()
      if (is.null(res)) NULL else f(res)
    })
  }
  if (!is.null(result_ui)) output$result <- when_result(result_ui)
  if (!is.null(details_ui)) output$result_details <- when_result(details_ui)
  if (!is.null(code)) output$code <- kit_render_code_panel(code, note = code_note)

  list(
    result = result,
    status = status,
    state = shiny::reactive(status()$state),
    run = run_now
  )
}
