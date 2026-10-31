# Shiny 模組：有狀態的元件，一頁一行就用得了
#
# 每個模組是一對 *_ui(id, ...) 與 *_server(id, ...)（moduleServer），server 回傳 reactive 的介面。
# 下面的低階函式（kit_step_head()、kit_navgroups()、kit_run_gate()、kit_render_code_panel()…）
# 仍然匯出：舊的 app 可以慢慢換。
#
# - kit_stepcards_*：步驟卡（哪一步打開、做完、還不能做；「對，下一步」與「改」；每步的摘要）
# - kit_step_tabs_*：步驟分頁（有順序的流程或分組；做完 ✓、還不能做、要重新執行）
# - kit_run_gate_*：主要按鈕＋「還差：…」
# - kit_code_panel_*：用 R 怎麼做（打開時才算程式碼）

# 步驟卡 -----------------------------------------------------------------------

#' 步驟卡模組（StepCard）
#'
#' 一頁裡有好幾步、而且有先後時用：一次只打開一步，做完的收成一行（✓、摘要、「改」），
#' 還不能做的是灰的。每一步最下面是「對，下一步」（一般按鈕）；按了以後這一步做完、
#' 打開下一個還沒做完的步驟。做完的按「改」回去。
#'
#' `kit_stepcards_ui()` 放每一步的內容（依順序）；`kit_stepcards_server()` 給每一步的標題、
#' 做完時的摘要、按「對，下一步」前的檢查。
#'
#' @param id 模組的 id。
#' @param ... 每一步的內容（一步一個 tag 或 `tagList()`，依順序）。
#' @param next_label 每一步最下面的按鈕字。
#' @return `kit_stepcards_ui()`：`tagList()`，裡面是一張張 [kit_step_card()]。
#'
#'   `kit_stepcards_server()`：list，
#'   - `current`：reactive，現在打開第幾步（都做完時是 0）；
#'   - `done`：reactive，每一步做完了沒有（logical 向量）；
#'   - `open(k)`：打開第 k 步（例如資料改了，要回第 1 步）；
#'   - `reset()`：全部回到還沒做，打開第 1 步。
#' @seealso [kit_step_card()]、[kit_step_head()]（低階）
#' @examples
#' if (interactive()) {
#'   ui <- kit_page("KIT 示範", NULL,
#'     kit_stepcards_ui("steps",
#'       shiny::p("每個檔案是哪個世代、哪個波次。"),
#'       shiny::p("哪些欄是題目。"),
#'       shiny::p("計分檢查。")
#'     )
#'   )
#'   server <- function(input, output, session) {
#'     steps <- kit_stepcards_server("steps",
#'       titles = c("每個檔案是哪個世代、哪個波次", "哪些欄是題目", "計分檢查"),
#'       summaries = list("5 個檔案", function() "45 題", "沒有要決定的事")
#'     )
#'   }
#'   shiny::shinyApp(ui, server)
#' }
#' @export
# 原文：對，下一步
kit_stepcards_ui <- function(id, ..., next_label = "\u5c0d\uff0c\u4e0b\u4e00\u6b65") {
  ns <- shiny::NS(id)
  steps <- list(...)
  shiny::tagList(lapply(seq_along(steps), function(k) {
    kit_step_card(
      shiny::uiOutput(ns(paste0("head", k))),
      shiny::conditionalPanel(
        paste0("output.open == '", k, "'"), ns = ns,
        kit_step_body(
          steps[[k]],
          shiny::uiOutput(ns(paste0("problems", k))),
          shiny::actionButton(ns(paste0("ok", k)), next_label)
        )
      ),
      title_id = ns(paste0("title", k))
    )
  }))
}

#' @rdname kit_stepcards_ui
#' @param titles 每一步的標題（字串向量，長度＝步數）。
#' @param summaries 每一步做完時的摘要：list，一步一個（字串、函式或 reactive；`NULL` 不顯示）。
#' @param checks 按「對，下一步」前的檢查：list，一步一個函式，傳回還差的事（字串向量；
#'   長度 0 = 可以往下）。還差時這一步不算做完，按鈕上面列出「還差：…」（[kit_problems()]）。
#' @param start 一開始打開第幾步。
#' @export
kit_stepcards_server <- function(id, titles, summaries = list(), checks = list(), start = 1L) {
  stopifnot(is.character(titles), length(titles) >= 1)
  n <- length(titles)
  value_of <- function(x) if (is.function(x)) x() else x
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns
    open <- shiny::reactiveVal(as.integer(start))
    done <- shiny::reactiveVal(rep(FALSE, n))
    problems <- shiny::reactiveVal(vector("list", n))

    output$open <- shiny::renderText(as.character(open()))
    shiny::outputOptions(output, "open", suspendWhenHidden = FALSE)

    next_open <- function(after, d) {
      todo <- which(!d & seq_len(n) > after)
      if (length(todo) == 0) todo <- which(!d)
      if (length(todo) == 0) 0L else as.integer(todo[1])
    }

    lapply(seq_len(n), function(k) {
      output[[paste0("head", k)]] <- shiny::renderUI({
        d <- done()
        state <- if (open() == k) "current" else if (d[k]) "done" else "locked"
        # 「改」：做完、而且前面的都做完了
        can_edit <- state == "done" && all(d[seq_len(k - 1)])
        summary <- if (state == "done" && length(summaries) >= k) value_of(summaries[[k]])
        kit_step_head(k, titles[[k]], state, summary = summary,
                      edit_id = if (can_edit) ns(paste0("edit", k)), title_id = ns(paste0("title", k)))
      })
      output[[paste0("problems", k)]] <- shiny::renderUI({
        # 原文：還差：
        kit_problems(problems()[[k]], head = "\u9084\u5dee\uff1a")
      })
      shiny::observeEvent(input[[paste0("ok", k)]], {
        check <- if (length(checks) >= k) checks[[k]]
        miss <- if (is.function(check)) check() else character(0)
        miss <- miss[!is.na(miss) & nzchar(miss)]
        p <- problems()
        p[k] <- list(if (length(miss) > 0) miss)
        problems(p)
        if (length(miss) > 0) return()
        d <- done()
        d[k] <- TRUE
        done(d)
        open(next_open(k, d))
      })
      shiny::observeEvent(input[[paste0("edit", k)]], open(k))
    })

    list(
      current = shiny::reactive(open()),
      done = shiny::reactive(done()),
      open = function(k) open(as.integer(k)),
      reset = function() {
        done(rep(FALSE, n))
        problems(vector("list", n))
        open(1L)
      }
    )
  })
}

# 步驟分頁 ---------------------------------------------------------------------

#' 步驟分頁模組（NavTabs）
#'
#' 兩種樣子，同一套狀態（做完 ✓、還不能做灰色＋原因、要重新執行 ✓ 拿掉）：
#'
#' - 有順序的流程（kitsUI）：不給 `groups`，`...` 的 `tabPanel()` 名稱用圈數字；
#'   `aside` 的分頁（例如「使用手冊」）虛線、放最右邊。
#' - 分組、不編號（kitJoin）：給 `groups`（[kit_navgroup()] 的 list）；分頁列是
#'   [kit_navgroups()]，真的分頁是藏起來的 `tabsetPanel()`。
#'
#' 分頁的 input 是 `input[["<id>-tabs"]]`；server 回傳的 `selected()` 是同一個值。
#'
#' @param id 模組的 id。
#' @param ... `shiny::tabPanel()`（`value` 要寫）。
#' @param groups 分組（[kit_navgroup()] 的 list）；`NULL` 是有順序的流程。
#' @param selected 一開始的分頁（value）。
#' @param aside 流程分頁裡不是流程一步的分頁（value）。
#' @return `kit_step_tabs_ui()`：分頁列與分頁。
#'
#'   `kit_step_tabs_server()`：list，
#'   - `selected`：reactive，現在的分頁（value）；
#'   - `select(value)`：換到某個分頁；
#'   - `states`：reactive，送到瀏覽器的狀態（[kit_tab_states()] 的結果）。
#' @seealso [kit_flow_tabs()]、[kit_navgroups()]、[kit_tab_states()]（低階）
#' @examples
#' if (interactive()) {
#'   ui <- kit_page("KIT 示範", NULL,
#'     kit_step_tabs_ui("nav",
#'       shiny::tabPanel("① 資料", value = "data", "…"),
#'       shiny::tabPanel("② 題目校準", value = "items", "…")
#'     )
#'   )
#'   server <- function(input, output, session) {
#'     kit_step_tabs_server("nav",
#'       states = shiny::reactive(c(data = "success", items = "locked")),
#'       tips = c(items = "先在「① 資料」選好資料")
#'     )
#'   }
#'   shiny::shinyApp(ui, server)
#' }
#' @export
kit_step_tabs_ui <- function(id, ..., groups = NULL, selected = NULL, aside = NULL) {
  ns <- shiny::NS(id)
  if (is.null(groups)) {
    return(kit_flow_tabs(..., id = ns("tabs"), selected = selected, aside = aside))
  }
  if (inherits(groups, "kit_navgroup")) groups <- list(groups)
  if (is.null(selected)) selected <- names(groups[[1]]$tabs)[1]
  shiny::tagList(
    kit_navgroups(groups, ns("tabs"), selected = selected),
    shiny::tabsetPanel(..., id = ns("tabs"), type = "hidden", selected = selected)
  )
}

#' @rdname kit_step_tabs_ui
#' @param states reactive（或函式）：每個分頁的狀態，具名字串向量或 list。值是
#'   [kit_status()] 的狀態（`"success"`、`"warning"` 打 ✓；`"stale"` 拿掉 ✓），
#'   或直接寫 `"done"`、`"locked"`、`"ready"`。沒有列出的分頁不改。`NULL` 時不送狀態。
#' @param tips 還不能做時滑過的說明：具名字串向量（或傳回它的 reactive），或一句話給全部。
#' @export
kit_step_tabs_server <- function(id, states = NULL, tips = NULL) {
  shiny::moduleServer(id, function(input, output, session) {
    tabset <- session$ns("tabs")
    value_of <- function(x) if (is.function(x)) x() else x
    tab_states <- shiny::reactive({
      if (is.null(states)) return(list())
      st <- as.list(value_of(states))
      locked <- names(st)[vapply(st, function(s) identical(as.character(s), "locked"), logical(1))]
      kit_tab_states(st, locked = locked, locked_tips = value_of(tips), tabset = tabset)
    })
    shiny::observe(kit_send_tab_states(tab_states(), session))
    list(
      selected = shiny::reactive(input$tabs),
      select = function(value) shiny::updateTabsetPanel(session, "tabs", selected = value),
      states = tab_states
    )
  })
}

# 主要按鈕＋還差 ---------------------------------------------------------------

#' 主要按鈕＋「還差：…」模組（ReadyLine）
#'
#' 主要按鈕一開始就顯示（停用）；還差的事（`missing()`）是空的時才能按，
#' 上面一行粗體「還差：…」，後面接一個去處理的連結。
#' server 回傳的 reactive 只有在**沒有還差的事時**按下去才會變（伺服器端也擋，
#' 不只靠按鈕停用），所以直接 `observeEvent(run(), …)` 就好。
#'
#' @param id 模組的 id。
#' @param label 主要按鈕的字（動詞開頭，例如「執行串接」）。
#' @param ... 其他傳給 [kit_button()] 的參數。
#' @return `kit_run_gate_ui()`：「還差」的位置與主要按鈕。
#'
#'   `kit_run_gate_server()`：reactive，可以執行時按了幾次（一開始是 0）。
#' @seealso [kit_ready_line()]、[kit_run_gate()]（低階）
#' @examples
#' if (interactive()) {
#'   ui <- kit_page("KIT 示範", NULL,
#'     shiny::selectInput("id_col", "ID 欄", c("", "subj_id")),
#'     kit_run_gate_ui("run", "執行串接")
#'   )
#'   server <- function(input, output, session) {
#'     run <- kit_run_gate_server("run", shiny::reactive(if (input$id_col == "") "選 ID 欄"))
#'     shiny::observeEvent(run(), message("執行"), ignoreInit = TRUE)
#'   }
#'   shiny::shinyApp(ui, server)
#' }
#' @export
kit_run_gate_ui <- function(id, label, ...) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::uiOutput(ns("ready")),
    kit_button(ns("run"), label, "primary", disabled = TRUE, ...)
  )
}

#' @rdname kit_run_gate_ui
#' @param missing reactive：還差的事（字串向量；長度 0 = 可以執行）。
#' @param link 函式：跟在「還差」後面的連結（tag 或 `NULL`）。
#' @export
kit_run_gate_server <- function(id, missing, link = function() NULL) {
  shiny::moduleServer(id, function(input, output, session) {
    kit_run_gate(session, output, missing, link = link)
    clicks <- shiny::reactiveVal(0L)
    shiny::observeEvent(input$run, {
      m <- missing()
      m <- m[!is.na(m) & nzchar(m)]
      if (length(m) == 0) clicks(clicks() + 1L)
    })
    shiny::reactive(clicks())
  })
}

# 用 R 怎麼做 ------------------------------------------------------------------

#' 「用 R 怎麼做」模組（CodePanel）
#'
#' 細節列裡的一個收合區塊；打開時才算程式碼（收起來時 Shiny 不畫裡面的 output），
#' 畫成一個或幾個 [kit_code()]（每行最多 70 欄、附「複製」）。
#'
#' @param id 模組的 id。
#' @param title 收合標題。
#' @param open 一開始要不要打開。
#' @return `kit_code_panel_ui()`：`<details class="kit-detail">`，放在 [kit_details_row()] 的最後。
#'
#'   `kit_code_panel_server()`：reactive，現在的程式碼（[kit_code()] 的 list；還沒有時是 `NULL`）。
#' @seealso [kit_code_panel()]、[kit_render_code_panel()]（低階）
#' @examples
#' if (interactive()) {
#'   ui <- kit_page("KIT 示範", NULL, kit_details_row(kit_code_panel_ui("code")))
#'   server <- function(input, output, session) {
#'     kit_code_panel_server("code", function() list(tidy = "x <- 1", base = "x <- 1"))
#'   }
#'   shiny::shinyApp(ui, server)
#' }
#' @export
# 原文：用 R 怎麼做
kit_code_panel_ui <- function(id, title = "\u7528 R \u600e\u9ebc\u505a", open = FALSE) {
  kit_code_panel(shiny::NS(id, "code"), title = title, open = open)
}

#' @rdname kit_code_panel_ui
#' @param code 傳回程式碼的函式或 reactive：一個字串、[kit_code()]，或它們的具名 list
#'   （見 [kit_code_blocks()] 的 `snips`）。
#' @param note,width,empty 見 [kit_render_code_panel()]。
#' @export
kit_code_panel_server <- function(id, code, note = KIT_CODE_NOTE, width = KIT_CODE_WIDTH,
                                  empty = KIT_CODE_EMPTY) {
  shiny::moduleServer(id, function(input, output, session) {
    output$code <- kit_render_code_panel(code, note = note, width = width, empty = empty)
    shiny::reactive({
      snips <- tryCatch(code(), error = function(e) NULL)
      if (is.null(snips)) NULL else kit_as_codes(snips, width)
    })
  })
}
