# 執行分頁（RunTab）：一頁一個主要按鈕的分頁骨架
#
# 頁面骨架（KIT 設計語言）由上到下：這一頁做什麼 → 設定 → 設定摘要 → 還差 → 主要按鈕 → 狀態框 →
# 重點 → 下載 → 細節列（結果的細節、用 R 怎麼做）→ 下一步。狀態流：改了設定 →【要重新執行】；
# 按主要按鈕 → 執行（進度條）→【完成】／【停下來】→ 通知、捲到狀態框。
# kitJoin 的每個分頁都是這個樣子；骨架在這裡，分頁只寫自己的設定、執行與結果。
# 不是 Shiny 模組：設定的 input 留在分頁自己的 namespace 裡（id 不變）。

#' 執行分頁（RunTab）
#'
#' 一頁一個主要按鈕的分頁骨架。`kit_run_tab_ui()` 照頁面骨架排好固定的部分，分頁自己的設定放在
#' `...`；`kit_run_tab_server()` 在分頁的 `moduleServer()` 裡呼叫，做好狀態流：
#'
#' - 主要按鈕：還差的事（`ready()`）不是空的時停用，上面一行「還差：…」（[kit_run_gate()]）。
#' - 設定摘要：`settings()` 的幾段接成一行（[kit_settings_line()]）。
#' - 按主要按鈕：清掉舊結果 → `guard()` → 進度條裡 `run()` → 結果存起來、`done(result)` 是狀態；
#'   出錯時 `error(e)` 是狀態 → 狀態框、通知（[kit_notify()]）、捲到狀態框（[kit_scroll_to()]）。
#' - 改了設定或資料（`stale_on()` 變了）而且有結果時：結果清掉，狀態是【要重新執行】。
#' - 結果的重點、細節列的第一格、用 R 怎麼做：有結果時才畫。
#'
#' 固定的 output id（不加 namespace）：`settings_line`、`ready`、`run`（按鈕）、`status`、
#' `result`、`downloads`、`result_details`、`code`、`next_step`。
#'
#' @param id 分頁（模組）的 id。
#' @param run_label 主要按鈕的字（動詞開頭，例如「執行串接」）。
#' @param guide 最上面的「這一頁做什麼」（[kit_tab_guide()]）。
#' @param ... 分頁自己的設定（輸入元件、提示），放在設定摘要上面。
#' @param gate `TRUE`：主要按鈕一開始停用，上面是「還差」；`FALSE`：一直能按（沒有 `ready`）。
#' @param result,downloads,next_step 狀態框下面的重點、下載區、最下面的下一步：`TRUE` 是
#'   `uiOutput()`（id 是 `result`、`downloads`、`next_step`），也可以直接給 tag；`FALSE` 不放。
#' @param details,code 細節列：`details = TRUE` 放 `uiOutput("result_details")`（結果的預覽與核對），
#'   `code = TRUE` 放「用 R 怎麼做」（[kit_code_panel()]，output `code`）；兩個都 `FALSE` 時沒有細節列。
#' @return `kit_run_tab_ui()`：`tagList()`。
#'
#'   `kit_run_tab_server()`：list，
#'   - `result`：`reactiveVal`，這一次的結果（還沒有、或過期了是 `NULL`）；
#'   - `status`：`reactiveVal`，狀態框的 [kit_status()]；
#'   - `state`：reactive，狀態框的狀態（步驟分頁打 ✓ 用，[kit_tab_states()]）；
#'   - `run(...)`：照按主要按鈕一樣執行一次（`...` 給 `run()`，例如確認視窗的「仍要執行」）。
#' @seealso [kit_run_gate()]、[kit_status()]、[kit_code_panel()]
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
#'         details = function(res) kit_detail("結果預覽", kit_static_table(res)),
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
#' @param input,output,session 分頁的 `moduleServer()` 的 input、output、session。
#' @param run 執行的函式：傳回結果（任何物件），或一個 [kit_status()]（沒有結果，例如有問題要先處理）。
#'   要停下來時 [kit_abort()]（白話的原因）。
#' @param done `function(result)`：執行完的狀態（[kit_done_status()]）；結果在呼叫前已經存好。
#' @param ready reactive：還差的事（字串向量；長度 0 = 可以執行）；`NULL` 時沒有「還差」（`gate = FALSE`）。
#' @param ready_link 函式：跟在「還差」後面的連結（tag 或 `NULL`）。
#' @param settings 函式：設定摘要的幾段（字串向量；`NULL` 時不顯示）；`NULL` 時沒有設定摘要。
#' @param stale_on 函式：改了會讓結果過期的東西（例如 `list(input$method, data())`）；
#'   `NULL` 時分頁自己處理（用回傳的 `result`、`status`）。
#' @param progress 進度條的訊息（「正在串接資料…」）；`NULL` 時沒有進度條。
#' @param error `function(e)`：出錯時的狀態；預設 `kit_error_status(e, run_label)`。
#' @param guard 函式：執行前的檢查，傳回 [kit_status()] 時不執行（狀態框與通知，不捲動）；`NULL` 不檢查。
#' @param confirm 要使用者確認的錯誤：具名 list，名字是 condition 的 class，值是 `function(e)`，
#'   跳出確認視窗、傳回狀態（不通知、不捲動，視窗就是回應）。確認以後用回傳的 `run(...)` 再執行。
#' @param result_ui `function(result)`：狀態框下面的重點（output `result`）；`NULL` 時分頁自己畫。
#' @param details_ui `function(result)`：細節列的第一格（output `result_details`，例如
#'   [kit_detail()]「結果預覽」）；`NULL` 時分頁自己畫。
#' @param code 函式：「用 R 怎麼做」的程式碼（[kit_render_code_panel()] 的 `code`）；`NULL` 時分頁自己畫。
#' @param code_note 「用 R 怎麼做」最上面的一行說明。
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
