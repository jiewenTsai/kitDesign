# server 端的 UI 小工具：還差什麼、捲到結果、打開收合區塊、離開前提醒

#' 還差什麼（ReadyLine）
#'
#' 主要按鈕還不能按時，按鈕上面一行粗體「還差：…」，後面接一個去處理的連結。
#' 「還差」寫具體的事和數字：「至少要 2 個波次的檔案，目前只有 1 個」。
#'
#' @param missing 還差的事（字串向量；`NA` 與 `""` 略過）。
#' @param link 跟在後面的連結（例如「到「檔案上傳」加入檔案 →」）；`NULL` 不顯示。
#' @return `<p class="kit-ready todo">`；不差什麼時是 `NULL`。
#' @seealso [kit_run_gate()]、[kit_need_files()]
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

#' 主要按鈕還不能按時：停用它，上面一行寫還差什麼
#'
#' 頁面上放 `shiny::uiOutput(ns("ready"))`，緊接著
#' `kit_button(ns("run"), ..., "primary", disabled = TRUE)`（一開始停用；伺服器算好以後才打開）。
#' 主要按鈕一開始就顯示，讓人知道這一頁最後要按什麼。
#'
#' 按鈕的 `observeEvent()` 裡仍要自己檢查一次：停用只是畫面上的，不能當成唯一的防線。
#'
#' @param session 模組的 session。
#' @param output 模組的 output。
#' @param missing reactive：還差的事（字串；長度 0 = 可以執行）。
#' @param link function()：跟在「還差」後面的連結（tag 或 `NULL`）。
#' @param button_id 主要按鈕的 id（模組內的 id，不加 `ns()`）。
#' @param output_id 放「還差」的 `uiOutput()` id（模組內的 id）。
#' @return 不可見的 `NULL`；在 server 裡呼叫。
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

#' 「還差」：檔案不夠時的那一句
#'
#' @param n_files 已經加入幾個檔案。
#' @param need 這一頁至少要幾個檔案。
#' @return 一句話；檔案夠了時是 `NULL`。
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

#' 執行完把狀態框捲到畫面上方
#'
#' 「先結果、後細節」：在主要按鈕的 `observeEvent()` 最後呼叫 `kit_scroll_to("status")`。
#' 等這一輪的 output 都送到瀏覽器以後（`session$onFlushed()`）才捲，狀態框已經畫好了。
#' 使用者設定「減少動態效果」時直接跳過去，不平滑捲動。
#'
#' @param id 模組裡的 output id（會自動加上模組的 namespace），例如 `"status"`。
#' @param session 預設是目前的 session（模組裡呼叫就是模組的 session）。
#' @return 不可見的完整 id；沒有 session 時是 `NULL`。
#' @examples
#' if (interactive()) {
#'   shiny::observeEvent(input$run, {
#'     # …執行…
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

#' 打開一個收合區塊（例如套用預設後打開進階設定）
#'
#' @param id `<details>` 的 id（模組內的 id，會自動加上 namespace），例如
#'   [kit_advanced()] 的 `id`。
#' @param session 預設是目前的 session。
#' @return 不可見的完整 id；沒有 session 時是 `NULL`。
#' @examples
#' if (interactive()) kit_open_details("advanced")
#' @export
kit_open_details <- function(id, session = shiny::getDefaultReactiveDomain()) {
  if (is.null(session)) return(invisible(NULL))
  full <- session$ns(id)
  session$sendCustomMessage("kit-open-details", full)
  invisible(full)
}

#' 離開頁面前的提醒
#'
#' 有這一回合的結果時（例如校準過），關掉或重新整理分頁前，瀏覽器會先問一次。
#' 在 server 裡依結果開關：`shiny::observe(kit_unload_guard(!is.null(result())))`。
#'
#' @param on `TRUE` 開、`FALSE` 關。
#' @param session 預設是目前的 session。
#' @return 不可見的 `on`。
#' @examples
#' if (interactive()) kit_unload_guard(TRUE)
#' @export
kit_unload_guard <- function(on = TRUE, session = shiny::getDefaultReactiveDomain()) {
  on <- isTRUE(on)
  if (!is.null(session)) session$sendCustomMessage("kit-unload-guard", on)
  invisible(on)
}
