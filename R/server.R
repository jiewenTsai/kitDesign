# server 端的 UI 小工具：還差什麼、捲到結果、打開收合區塊、離開前提醒

#' Ready line ("what's still needed")
#'
#' When the primary button cannot be pressed yet, a bold line above it says "還差：…" ("Still
#' needed: …"), followed by a link to where to fix it.
#' Write what is still needed as concrete tasks and numbers: "至少要 2 個波次的檔案，目前只有 1 個"
#' ("Need files from at least 2 waves; there is only 1 now").
#'
#' @param missing What is still needed (character vector; `NA` and `""` are skipped).
#' @param link A link that follows (for example "到「檔案上傳」加入檔案 →", "Go to 'File upload'
#'   to add files →"); `NULL` shows nothing.
#' @return `<p class="kit-ready todo">`; `NULL` when nothing is missing.
#' @seealso [kit_run_gate()], [kit_need_files()]
#' @examples
#' kit_ready_line(c("至少要 2 個波次的檔案，目前只有 1 個", "選 ID 欄"))
#' @export
kit_ready_line <- function(missing, link = NULL) {
  missing <- missing[!is.na(missing) & nzchar(missing)]
  if (length(missing) == 0) return(NULL)
  shiny::tags$p(
    class = "kit-ready todo",
    # 原文：還差： | ； | 。
    paste0("\u9084\u5dee\uff1a", paste(missing, collapse = "\uff1b"), "\u3002"),
    if (!is.null(link)) " ", link
  )
}

#' When the primary button cannot be pressed yet: disable it and show what is still needed above it
#'
#' Put `shiny::uiOutput(ns("ready"))` on the page, directly followed by
#' `kit_button(ns("run"), ..., "primary", disabled = TRUE)` (disabled at first; enabled once the
#' server has checked). The primary button is shown from the start, so people know what they will
#' press at the end of this page.
#'
#' Still check again inside the button's `observeEvent()`: disabling is only on screen and must not
#' be the only safeguard.
#'
#' @param session The module's session.
#' @param output The module's output.
#' @param missing A reactive: what is still needed (character; length 0 = ready to run).
#' @param link function(): the link after "還差" ("Still needed") (a tag or `NULL`).
#' @param button_id The primary button's id (the id inside the module, without `ns()`).
#' @param output_id The `uiOutput()` id for the "還差" line (the id inside the module).
#' @return `NULL`, invisibly; call it inside the server.
#' @examples
#' if (interactive()) {
#'   server <- function(input, output, session) {
#'     kit_run_gate(session, output, shiny::reactive(kit_need_files(1L, need = 2L)))
#'   }
#' }
#' @export
kit_run_gate <- function(session, output, missing, link = function() NULL, button_id = "run",
                         output_id = "ready") {
  output[[output_id]] <- shiny::renderUI({
    m <- missing()
    kit_ready_line(m, if (length(m) > 0) link())
  })
  shiny::observe({
    shiny::updateActionButton(session, button_id, disabled = length(missing()) > 0)
  })
  invisible(NULL)
}

#' "還差" ("Still needed"): the sentence shown when there are not enough files
#'
#' @param n_files How many files have been added.
#' @param need The minimum number of files this page needs.
#' @return One sentence; `NULL` when there are enough files.
#' @examples
#' kit_need_files(1L, need = 2L)
#' kit_need_files(0L, need = 1L)
#' @export
kit_need_files <- function(n_files, need = 2L) {
  if (n_files >= need) return(NULL)
  # 原文：先加入檔案
  if (need == 1L) return("\u5148\u52a0\u5165\u6a94\u6848")
  # 原文：至少要  |  個波次的檔案，目前
  paste0("\u81f3\u5c11\u8981 ", need, " \u500b\u6ce2\u6b21\u7684\u6a94\u6848\uff0c\u76ee\u524d",
         # 原文：還沒有 | 只有  |  個
         if (n_files == 0) "\u9084\u6c92\u6709" else paste0("\u53ea\u6709 ", n_files, " \u500b"))
}

#' After running, scroll the status box to the top of the screen
#'
#' "Results first, details after": call `kit_scroll_to("status")` at the end of the primary
#' button's `observeEvent()`. It scrolls only after this round's outputs have all reached the
#' browser (`session$onFlushed()`), so the status box is already rendered.
#' When the user has set "reduce motion", it jumps there without smooth scrolling.
#'
#' @param id The output id inside the module (the module's namespace is added automatically), for
#'   example `"status"`.
#' @param session Defaults to the current session (called inside a module, that is the module's
#'   session).
#' @return The full id, invisibly; `NULL` when there is no session.
#' @examples
#' if (interactive()) {
#'   shiny::observeEvent(input$run, {
#'     # …run…
#'     kit_scroll_to("status")
#'   })
#' }
#' @export
kit_scroll_to <- function(id, session = shiny::getDefaultReactiveDomain()) {
  if (is.null(session)) return(invisible(NULL))
  full <- session$ns(id)
  session$onFlushed(function() {
    session$sendCustomMessage("kit-scroll", full)
  }, once = TRUE)
  invisible(full)
}

#' Open a collapsible section (for example, open the advanced settings after applying a preset)
#'
#' @param id The id of the `<details>` (the id inside the module; the namespace is added
#'   automatically), for example the `id` of [kit_advanced()].
#' @param session Defaults to the current session.
#' @return The full id, invisibly; `NULL` when there is no session.
#' @examples
#' if (interactive()) kit_open_details("advanced")
#' @export
kit_open_details <- function(id, session = shiny::getDefaultReactiveDomain()) {
  if (is.null(session)) return(invisible(NULL))
  full <- session$ns(id)
  session$sendCustomMessage("kit-open-details", full)
  invisible(full)
}

#' Reminder before leaving the page
#'
#' When there are results from this session (for example, after calibration), the browser asks once
#' before the tab is closed or reloaded.
#' Turn it on and off in the server based on the result:
#' `shiny::observe(kit_unload_guard(!is.null(result())))`.
#'
#' @param on `TRUE` turns it on, `FALSE` turns it off.
#' @param session Defaults to the current session.
#' @return `on`, invisibly.
#' @examples
#' if (interactive()) kit_unload_guard(TRUE)
#' @export
kit_unload_guard <- function(on = TRUE, session = shiny::getDefaultReactiveDomain()) {
  on <- isTRUE(on)
  if (!is.null(session)) session$sendCustomMessage("kit-unload-guard", on)
  invisible(on)
}
