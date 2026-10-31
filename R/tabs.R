# 步驟分頁（NavTabs）
#
# 兩種：
# - 有順序的流程（kitsUI）：① 資料 → ② 題目校準 → ③ 連結 → ④ 受試者評分，用圈數字。
#   kit_flow_tabs()：看得到的 tabsetPanel。
# - 不是每一頁都要做（kitJoin）：分組、不編號，每組上面一行灰色組標籤。
#   kit_navgroups() 畫分頁列，真的分頁是 tabsetPanel(type = "hidden")，
#   所以 input$tabs 與 updateTabsetPanel() 照常可以用。
# 兩種都用同一套狀態：做完打 ✓、還不能做灰色（滑過時說明要先做什麼）、要重新執行時 ✓ 拿掉。
# 伺服器算好每個分頁的狀態（kit_tab_states()），用 kit-tab-states 訊息送到瀏覽器（kit.js）。

#' One group in the tab bar (for [kit_navgroups()])
#'
#' @param label The group label (small gray text), e.g. "準備" ("Prepare"), "做出資料（選一個）"
#'   ("Make the data (pick one)"), "其他工具" ("Other tools").
#' @param tabs A named character vector: names are tab values (`tabPanel(value = )`), values are tab
#'   names.
#' @param tools When `TRUE`, these are standalone tools: dashed border, no shadow.
#' @return A list (`class = "kit_navgroup"`).
#' @examples
#' kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理"))
#' # "Prepare": "File upload", "Missing values"
#' @export
kit_navgroup <- function(label, tabs, tools = FALSE) {
  stopifnot(is.character(tabs), !is.null(names(tabs)), all(nzchar(names(tabs))))
  structure(list(label = label, tabs = tabs, class = if (isTRUE(tools)) "tools"),
            class = "kit_navgroup")
}

#' Grouped tab bar (unnumbered; the kitJoin style)
#'
#' Tabs are split into groups, each with a line of small gray text above it. On click, `kit.js`
#' switches the hidden `tabsetPanel(id = tabset, type = "hidden")`; after a switch (including
#' `updateTabsetPanel()`) it marks the current tab as active. The ✓ for done tabs and the gray for
#' tabs not yet usable are also applied to these links ([kit_send_tab_states()]). At ≤ 768px the bar
#' becomes one row that scrolls sideways.
#'
#' @param groups A list of [kit_navgroup()].
#' @param tabset The id of the matching `tabsetPanel()`.
#' @param selected The tab to start on (value); defaults to the first.
#' @return `<nav class="kit-navgroups">`.
#' @examples
#' groups <- list(
#'   kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理")),
#'   kit_navgroup("做出資料（選一個）", c(join = "橫向資料串接", stack = "直向波次疊加")),
#'   kit_navgroup("其他工具", c(convert = "檔案格式轉換"), tools = TRUE)
#' )
#' # Groups: "Prepare" (File upload, Missing values), "Make the data (pick one)"
#' # (Wide join, Long stack of waves), "Other tools" (File format conversion)
#' kit_navgroups(groups, "tabs")
#' # Then on the page:
#' # shiny::tabsetPanel(id = "tabs", type = "hidden",
#' #   shiny::tabPanel("檔案上傳", value = "upload", ...), ...)
#' @export
kit_navgroups <- function(groups, tabset = "tabs", selected = NULL) {
  if (inherits(groups, "kit_navgroup")) groups <- list(groups)
  if (is.null(selected)) selected <- names(groups[[1]]$tabs)[1]
  shiny::tags$nav(
    # 原文：分頁
    class = "kit-navgroups", `data-tabset` = tabset, `aria-label` = "\u5206\u9801",
    lapply(groups, function(g) {
      shiny::tags$div(
        class = paste(c("kit-navgroup", g$class), collapse = " "),
        shiny::tags$div(class = "kit-navgroup-label", g$label),
        shiny::tags$ul(
          class = "nav nav-tabs",
          lapply(names(g$tabs), function(value) {
            shiny::tags$li(
              class = "nav-item",
              shiny::tags$a(
                class = paste(c("nav-link", if (value == selected) "active"), collapse = " "),
                href = "#", `data-kit-tab` = value,
                `aria-current` = if (value == selected) "page",
                g$tabs[[value]]
              )
            )
          })
        )
      )
    })
  )
}

#' Ordered workflow tabs (the kitsUI style)
#'
#' A regular `shiny::tabsetPanel()` with circled numbers in the tab names (① 資料, ② 題目校準…;
#' "Data", "Item calibration"). Tabs that are not a workflow step (e.g. "使用手冊", "User manual") go
#' in `aside`: dashed border, no shadow, pushed to the far right. Done tabs get a ✓ (an extra
#' `.kit-tab-mark` in the tab); tabs that can't be used yet are gray ([kit_send_tab_states()]).
#'
#' @param ... `shiny::tabPanel()`.
#' @param id The tabsetPanel id (`input[[id]]` is the current tab).
#' @param selected The tab to start on (value).
#' @param aside Values of tabs that are not a workflow step (a character vector).
#' @return `<div class="kit-flow-tabs">` containing a `tabsetPanel()`.
#' @examples
#' kit_flow_tabs(
#'   shiny::tabPanel("① 資料", value = "data"),
#'   shiny::tabPanel("② 題目校準", value = "items"),
#'   shiny::tabPanel("使用手冊", value = "manual"),
#'   id = "flow", aside = "manual"
#' )
#' @export
kit_flow_tabs <- function(..., id = "tabs", selected = NULL, aside = NULL) {
  shiny::tags$div(
    class = "kit-flow-tabs",
    `data-kit-aside` = if (length(aside) > 0) paste(aside, collapse = "|"),
    shiny::tabsetPanel(..., id = id, selected = selected)
  )
}

# 分頁狀態的說明（滑過時）
KIT_TAB_TIPS <- c(
  # 原文：已完成
  done = "\u5df2\u5b8c\u6210",
  # 原文：已完成，但有要注意的地方
  warning = "\u5df2\u5b8c\u6210\uff0c\u4f46\u6709\u8981\u6ce8\u610f\u7684\u5730\u65b9",
  # 原文：設定或檔案改過了：要重新執行
  stale = "\u8a2d\u5b9a\u6216\u6a94\u6848\u6539\u904e\u4e86\uff1a\u8981\u91cd\u65b0\u57f7\u884c",
  # 原文：還不能用：先完成前面的步驟
  locked = "\u9084\u4e0d\u80fd\u7528\uff1a\u5148\u5b8c\u6210\u524d\u9762\u7684\u6b65\u9a5f"
)

#' State of each tab
#'
#' Works out how each tab looks from the state of its status box (the `state` of [kit_status()]):
#'
#' - `"locked"` (gray): tabs listed in `locked`. The hover text is `locked_tips`.
#' - `"done"` (with ✓): the state is `"success"` or `"warning"` (or directly `"done"`).
#' - `"stale"` (✓ removed): the state is `"stale"`.
#' - `"ready"`: anything else (`"idle"`, `"error"`, `"ready"`).
#'
#' Pass the result to [kit_send_tab_states()] (or [kit_watch_tab_states()]) to send it to the
#' browser.
#'
#' @param status A named list or character vector: names are tab values, values are states.
#'   Tabs not listed are left unchanged.
#' @param locked Tabs that cannot be used yet: a character vector of values, or a named logical.
#' @param locked_tips The hover text for tabs that cannot be used yet: one string (the same for all),
#'   or a character vector named by value.
#' @param tabset The tabset id (`tabsetPanel(id = )`).
#' @return A list with one `list(tabset, value, state, tip)` per tab.
#' @examples
#' kit_tab_states(
#'   list(upload = "success", missing = "stale", join = "idle"),
#'   locked = "join", locked_tips = c(join = "還不能用：先加入至少 2 個檔案")
#' )
#' @export
kit_tab_states <- function(status, locked = character(0), locked_tips = NULL, tabset = "tabs") {
  status <- as.list(status)
  if (is.logical(locked)) locked <- names(locked)[locked %in% TRUE]
  values <- unique(c(names(status), locked))
  lapply(values, function(v) {
    st <- kit_state_name(status[[v]] %||% "idle")
    state <- if (v %in% locked) {
      "locked"
    } else if (st %in% c("success", "warning", "done")) {
      "done"
    } else if (identical(st, "stale")) {
      "stale"
    } else if (identical(st, "locked")) {
      "locked"
    } else {
      "ready"
    }
    tip <- switch(state,
      locked = {
        t <- if (length(locked_tips) == 1 && is.null(names(locked_tips))) locked_tips else locked_tips[v]
        t <- unname(t)
        if (length(t) == 1 && !is.na(t)) t else KIT_TAB_TIPS[["locked"]]
      },
      done = if (identical(st, "warning")) KIT_TAB_TIPS[["warning"]] else KIT_TAB_TIPS[["done"]],
      stale = KIT_TAB_TIPS[["stale"]],
      NULL
    )
    list(tabset = tabset, value = v, state = state, tip = tip)
  })
}

#' Send tab states to the browser
#'
#' Works with both kinds of tab bar: grouped tab bars ([kit_navgroups()], `data-tabset` is `tabset`)
#' and flow tabs ([kit_flow_tabs()], `id` is `tabset`).
#'
#' @param states The result of [kit_tab_states()].
#' @param session Defaults to the current session.
#' @return `states`, invisibly.
#' @examples
#' if (interactive()) kit_send_tab_states(kit_tab_states(list(upload = "success")))
#' @export
kit_send_tab_states <- function(states, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) session$sendCustomMessage("kit-tab-states", states)
  invisible(states)
}

#' Send tab states to the browser whenever they change
#'
#' `kit_watch_tab_states(session, shiny::reactive(kit_tab_states(...)))`.
#'
#' @param session The Shiny session.
#' @param states A reactive: the result of [kit_tab_states()].
#' @return The `shiny::observe()` observer (invisibly).
#' @examples
#' if (interactive()) {
#'   server <- function(input, output, session) {
#'     kit_watch_tab_states(session, shiny::reactive(kit_tab_states(list(upload = "success"))))
#'   }
#' }
#' @export
kit_watch_tab_states <- function(session, states) {
  invisible(shiny::observe({
    kit_send_tab_states(states(), session)
  }))
}
