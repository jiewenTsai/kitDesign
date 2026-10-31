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

#' Step card module
#'
#' Use when a page has several steps that must be done in order: only one step is open at a time;
#' finished steps collapse to one line (✓, summary, "改" ("Edit")), and steps not yet available are
#' gray. Each step ends with "對，下一步" ("Yes, next step") (a regular button); pressing it marks
#' the step done and opens the next unfinished step. Press "改" on a finished step to go back.
#'
#' `kit_stepcards_ui()` holds the content of each step (in order); `kit_stepcards_server()` gives
#' each step's title, its summary when done, and the check before "對，下一步" is pressed.
#'
#' @param id The module id.
#' @param ... The content of each step (one tag or `tagList()` per step, in order).
#' @param next_label The button text at the bottom of each step.
#' @return `kit_stepcards_ui()`: a `tagList()` of [kit_step_card()]s.
#'
#'   `kit_stepcards_server()`: a list,
#'   - `current`: a reactive, which step is open now (0 when all are done);
#'   - `done`: a reactive, whether each step is done (logical vector);
#'   - `open(k)`: opens step k (for example, back to step 1 when the data change);
#'   - `reset()`: marks all steps as not done and opens step 1.
#' @seealso [kit_step_card()], [kit_step_head()] (low-level)
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
#' @param titles The title of each step (character vector, length = number of steps).
#' @param summaries The summary shown when each step is done: a list, one per step (a string,
#'   function, or reactive; `NULL` shows nothing).
#' @param checks Checks before "對，下一步" ("Yes, next step") is pressed: a list, one function per
#'   step, returning what is still needed (character vector; length 0 = can move on). While
#'   something is still needed, the step is not done, and "還差：…" ("Still needed: …") is listed
#'   above the button ([kit_problems()]).
#' @param start Which step is open at the start.
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

#' Step tabs module
#'
#' Two looks, one set of states (done ✓; not yet available gray plus the reason; run again removes
#' the ✓):
#'
#' - Ordered flow (kitsUI): do not pass `groups`; the `tabPanel()` names in `...` use circled
#'   numbers; `aside` tabs (for example "使用手冊", "User manual") are dashed and placed at the far
#'   right.
#' - Grouped, unnumbered (kitJoin): pass `groups` (a list of [kit_navgroup()]); the tab bar is
#'   [kit_navgroups()], and the real tabs are a hidden `tabsetPanel()`.
#'
#' The tabs' input is `input[["<id>-tabs"]]`; the `selected()` returned by the server is the same
#' value.
#'
#' @param id The module id.
#' @param ... `shiny::tabPanel()`s (`value` is required).
#' @param groups Groups (a list of [kit_navgroup()]); `NULL` means an ordered flow.
#' @param selected The tab selected at the start (value).
#' @param aside Tabs in a flow that are not a step of the flow (value).
#' @return `kit_step_tabs_ui()`: the tab bar and the tabs.
#'
#'   `kit_step_tabs_server()`: a list,
#'   - `selected`: a reactive, the current tab (value);
#'   - `select(value)`: switches to a tab;
#'   - `states`: a reactive, the states sent to the browser (the result of [kit_tab_states()]).
#' @seealso [kit_flow_tabs()], [kit_navgroups()], [kit_tab_states()] (low-level)
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
#' @param states A reactive (or function): the state of each tab, a named character vector or list.
#'   Values are [kit_status()] states (`"success"` and `"warning"` add a ✓; `"stale"` removes the
#'   ✓), or directly `"done"`, `"locked"`, `"ready"`. Tabs not listed are left unchanged. With
#'   `NULL`, no states are sent.
#' @param tips The hover text for tabs not yet available: a named character vector (or a reactive
#'   that returns one), or one sentence for all.
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

#' Primary button + "Still needed: …" module (ready line)
#'
#' The primary button is shown (disabled) from the start; it can be pressed only when nothing is
#' still needed (`missing()` is empty). Above it, a bold line says "還差：…" ("Still needed: …"),
#' followed by a link to where to fix it. The reactive returned by the server changes only when the
#' button is pressed **while nothing is still needed** (the server also blocks it, not just the
#' disabled button), so a plain `observeEvent(run(), …)` is enough.
#'
#' @param id The module id.
#' @param label The primary button's text (start with a verb, for example "執行串接", "Run join").
#' @param ... Other arguments passed to [kit_button()].
#' @return `kit_run_gate_ui()`: the slot for the "還差" line and the primary button.
#'
#'   `kit_run_gate_server()`: a reactive counting presses made while ready to run (0 at first).
#' @seealso [kit_ready_line()], [kit_run_gate()] (low-level)
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
#' @param missing A reactive: what is still needed (character vector; length 0 = ready to run).
#' @param link A function: the link after "還差" ("Still needed") (a tag or `NULL`).
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

#' "How to do it in R" module (code panel)
#'
#' A collapsible block in the details row; the code is computed only when it is opened (Shiny does
#' not render outputs inside a collapsed block), and rendered as one or more [kit_code()] (at most
#' 70 columns per line, with "Copy").
#'
#' @param id The module id.
#' @param title The collapsible title.
#' @param open Whether it starts open.
#' @return `kit_code_panel_ui()`: `<details class="kit-detail">`, placed last in
#'   [kit_details_row()].
#'
#'   `kit_code_panel_server()`: a reactive with the current code (a list of [kit_code()]; `NULL`
#'   when there is none yet).
#' @seealso [kit_code_panel()], [kit_render_code_panel()] (low-level)
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
#' @param code A function or reactive returning the code: a string, a [kit_code()], or a named list
#'   of them (see `snips` in [kit_code_blocks()]).
#' @param note,width,empty See [kit_render_code_panel()].
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
