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

#' 分頁列的一組（給 [kit_navgroups()]）
#'
#' @param label 組標籤（灰色小字），例如「準備」「做出資料（選一個）」「其他工具」。
#' @param tabs 具名字串向量：名字是分頁的 value（`tabPanel(value = )`），值是分頁名稱。
#' @param tools `TRUE` 時是獨立的小工具：虛線框、沒有陰影。
#' @return list（`class = "kit_navgroup"`）。
#' @examples
#' kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理"))
#' @export
kit_navgroup <- function(label, tabs, tools = FALSE) {
  stopifnot(is.character(tabs), !is.null(names(tabs)), all(nzchar(names(tabs))))
  structure(list(label = label, tabs = tabs, class = if (isTRUE(tools)) "tools"),
            class = "kit_navgroup")
}

#' 分組的分頁列（不編號；kitJoin 的樣子）
#'
#' 分頁分成幾組，每組上面一行灰色小字。按下去時由 `kit.js` 切換藏起來的
#' `tabsetPanel(id = tabset, type = "hidden")`；切換以後（包括 `updateTabsetPanel()`）
#' 再把目前的分頁標成 active。做完打 ✓、還不能用變灰也加在這些連結上
#' （[kit_send_tab_states()]）。≤ 768px 時一排左右滑。
#'
#' @param groups [kit_navgroup()] 的 list。
#' @param tabset 對應的 `tabsetPanel()` 的 id。
#' @param selected 一開始的分頁（value）；預設是第一個。
#' @return `<nav class="kit-navgroups">`。
#' @examples
#' groups <- list(
#'   kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理")),
#'   kit_navgroup("做出資料（選一個）", c(join = "橫向資料串接", stack = "直向波次疊加")),
#'   kit_navgroup("其他工具", c(convert = "檔案格式轉換"), tools = TRUE)
#' )
#' kit_navgroups(groups, "tabs")
#' # 頁面上接著放：
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

#' 有順序的流程分頁（kitsUI 的樣子）
#'
#' 一般的 `shiny::tabsetPanel()`，分頁名稱用圈數字（① 資料、② 題目校準…）。
#' 不是流程一步的分頁（例如「使用手冊」）寫在 `aside`：虛線框、沒有陰影、推到最右邊。
#' 做完打 ✓（分頁裡多一個 `.kit-tab-mark`）、還不能做灰色（[kit_send_tab_states()]）。
#'
#' @param ... `shiny::tabPanel()`。
#' @param id tabsetPanel 的 id（`input[[id]]` 是目前的分頁）。
#' @param selected 一開始的分頁（value）。
#' @param aside 不是流程一步的分頁的 value（字串向量）。
#' @return `<div class="kit-flow-tabs">`，裡面是 `tabsetPanel()`。
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

#' 每個分頁的狀態
#'
#' 從每個分頁狀態框的狀態（[kit_status()] 的 `state`）算出分頁的樣子：
#'
#' - `"locked"`（灰色）：寫在 `locked` 裡的分頁。滑過時的說明是 `locked_tips`。
#' - `"done"`（打 ✓）：狀態是 `"success"` 或 `"warning"`（或直接寫 `"done"`）。
#' - `"stale"`（✓ 拿掉）：狀態是 `"stale"`。
#' - `"ready"`：其他（`"idle"`、`"error"`、`"ready"`）。
#'
#' 結果交給 [kit_send_tab_states()]（或 [kit_watch_tab_states()]）送到瀏覽器。
#'
#' @param status 具名 list 或字串向量：名字是分頁的 value，值是狀態。
#'   沒有列出的分頁不改。
#' @param locked 還不能用的分頁：value 的字串向量，或具名 logical。
#' @param locked_tips 還不能用時滑過的說明：一個字串（全部一樣），或以 value 命名的字串向量。
#' @param tabset 分頁的 id（`tabsetPanel(id = )`）。
#' @return list，一個分頁一個 `list(tabset, value, state, tip)`。
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

#' 把分頁狀態送到瀏覽器
#'
#' 兩種分頁列都適用：分組分頁列（[kit_navgroups()]，`data-tabset` 是 `tabset`）與
#' 流程分頁（[kit_flow_tabs()]，`id` 是 `tabset`）。
#'
#' @param states [kit_tab_states()] 的結果。
#' @param session 預設是目前的 session。
#' @return 不可見的 `states`。
#' @examples
#' if (interactive()) kit_send_tab_states(kit_tab_states(list(upload = "success")))
#' @export
kit_send_tab_states <- function(states, session = shiny::getDefaultReactiveDomain()) {
  if (!is.null(session)) session$sendCustomMessage("kit-tab-states", states)
  invisible(states)
}

#' 分頁狀態一變就送到瀏覽器
#'
#' `kit_watch_tab_states(session, shiny::reactive(kit_tab_states(...)))`。
#'
#' @param session Shiny session。
#' @param states reactive：[kit_tab_states()] 的結果。
#' @return `shiny::observe()` 的 observer（不可見）。
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
