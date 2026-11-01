# 互動資料表（DT）與範圍選擇列

#' Interactive table (DT) with the KIT look
#'
#' For tables people search, page through, and click: search results, item lists to edit.
#' Same look as [kit_static_table()]: 2px frame, black header with white text, zebra stripes,
#' `small` type, numbers right-aligned; a selected row is light lime (`bg-new`), not blue. Text is
#' in Traditional Chinese ("共 37 列，第 1–20 列", "上一頁", "下一頁"); the page buttons look like
#' small buttons. Width fits the content; on a phone a wide table scrolls sideways inside its own
#' box, never the page.
#'
#' Use it inside `DT::renderDT()`. 'DT' is in Suggests: the app itself needs `Imports: DT`.
#' For short result tables that need no paging, use [kit_static_table()].
#'
#' @param df A data.frame. Column names stay as they are (data and function output keep their
#'   English names).
#' @param selection `"none"`, `"single"`, or `"multiple"` (click to select rows). A list is passed
#'   to `DT::datatable(selection = )` as it is (for example with `selected = `).
#' @param page_length Rows per page. 0 shows all rows (no paging).
#' @param search Show the table's own search box. Usually `FALSE`: the page has its own
#'   conditions.
#' @param wrap_cols Columns whose long text wraps (for example the item text); other columns do
#'   not wrap.
#' @param min_widths Named vector of minimum column widths in CSS units, for example
#'   `c(label = "24rem")`.
#' @param ordering Click the header to sort.
#' @param options More DataTables options (override the defaults). `columnDefs` given here come
#'   first, so they win over the ones `kit_dt()` makes.
#' @param ... Passed to `DT::datatable()`.
#' @return A `datatables` htmlwidget with class `kit-dt`.
#' @seealso [kit_static_table()] for short result tables, [kit_table_scroll()].
#' @examples
#' if (requireNamespace("DT", quietly = TRUE)) {
#'   kit_dt(data.frame(itemID = c("a1", "a2"), label = c("睡眠時間", "午睡")),
#'          selection = "single", wrap_cols = "label")
#' }
#' @export
kit_dt <- function(df, selection = "none", page_length = 20L, search = FALSE,
                   wrap_cols = NULL, min_widths = NULL, ordering = TRUE,
                   options = list(), ...) {
  if (!requireNamespace("DT", quietly = TRUE)) {
    stop("kit_dt() needs the 'DT' package: install.packages(\"DT\").", call. = FALSE)
  }
  df <- as.data.frame(df, stringsAsFactors = FALSE, check.names = FALSE)
  cols <- names(df)
  # DataTables uses the first columnDef that sets a property for a column (a later className
  # does not add to an earlier one), so each column gets exactly one def with all its classes.
  # DT adds "dt-right" to numeric columns only when no className is set: add it here.
  is_num <- vapply(df, is.numeric, logical(1))
  col_defs <- lapply(seq_along(cols), function(j) {
    nm <- cols[[j]]
    def <- list(
      targets = j - 1L,
      className = paste(c(if (nm %in% wrap_cols) "kit-dt-wrap" else "kit-dt-nowrap",
                          if (is_num[[j]]) "dt-right"), collapse = " ")
    )
    if (!is.null(min_widths) && nm %in% names(min_widths)) def$width <- min_widths[[nm]]
    def
  })
  paging <- page_length > 0L
  # dom: the parts sit in divs with kit-dt-* classes, so the CSS reaches the search box, the
  # pager and the scroll box without touching other DataTables on the page
  dom <- paste0(
    "<\"kit-dt-box\"",
    if (search) "<\"kit-dt-top\"f>",
    "<\"kit-dt-scroll\"t>",
    "<\"kit-dt-foot\"", if (paging) "ip" else "i", ">",
    ">"
  )
  defaults <- list(
    dom = dom,
    pageLength = if (paging) as.integer(page_length) else -1L,
    paging = paging,
    ordering = ordering,
    autoWidth = FALSE,
    language = kit_dt_language()
  )
  options <- utils::modifyList(defaults, options)
  options$columnDefs <- c(options$columnDefs, col_defs)
  mode <- if (is.list(selection)) selection$mode %||% "multiple" else selection
  class <- paste(c("kit-dt compact", if (!identical(mode, "none")) "kit-dt-selectable"),
                 collapse = " ")
  DT::datatable(
    df,
    rownames = FALSE,
    selection = selection,
    class = class,
    style = "default",
    options = options,
    ...
  )
}

#' DataTables text in Traditional Chinese
#' @noRd
kit_dt_language <- function() {
  # Mark every string as UTF-8: unmarked ("unknown") strings warn "cannot be translated from
  # 'US-ASCII' to UTF-8" when the widget is turned into JSON in a non-UTF-8 locale (testthat,
  # some Windows sessions).
  mark_utf8 <- function(x) {
    if (is.list(x)) return(lapply(x, mark_utf8))
    x <- enc2utf8(x)
    Encoding(x) <- "UTF-8"
    x
  }
  mark_utf8(list(
    # 原文：共 _TOTAL_ 列，第 _START_–_END_ 列
    info = "\u5171 _TOTAL_ \u5217\uff0c\u7b2c _START_\u2013_END_ \u5217",
    # 原文：共 0 列
    infoEmpty = "\u5171 0 \u5217",
    # 原文：（從 _MAX_ 列篩出）
    infoFiltered = "\uff08\u5f9e _MAX_ \u5217\u7be9\u51fa\uff09",
    # 原文：搜尋：
    search = "\u641c\u5c0b\uff1a",
    # 原文：沒有符合的資料
    zeroRecords = "\u6c92\u6709\u7b26\u5408\u7684\u8cc7\u6599",
    # 原文：沒有符合的資料
    emptyTable = "\u6c92\u6709\u7b26\u5408\u7684\u8cc7\u6599",
    thousands = ",",
    paginate = list(
      # 原文：上一頁 | 下一頁
      previous = "\u4e0a\u4e00\u9801", `next` = "\u4e0b\u4e00\u9801",
      # 原文：第一頁 | 最後一頁
      first = "\u7b2c\u4e00\u9801", last = "\u6700\u5f8c\u4e00\u9801"
    ),
    aria = list(
      # 原文：：按一下由小到大排序
      sortAscending = "\uff1a\u6309\u4e00\u4e0b\u7531\u5c0f\u5230\u5927\u6392\u5e8f",
      # 原文：：按一下由大到小排序
      sortDescending = "\uff1a\u6309\u4e00\u4e0b\u7531\u5927\u5230\u5c0f\u6392\u5e8f"
    )
  ))
}

#' Scope bar: an app-wide choice under the tab bar
#'
#' For a choice that every tab of the app depends on, such as which item bank is in use. It sits
#' right under the tab bar, without a frame: a radio group (or a select), one line of small hint
#' text (what is in use now, how big it is), small buttons on the right, and an optional area for
#' what must be confirmed after choosing (a checklist and buttons). A thin line separates it from
#' the page below.
#'
#' Markup: `div.kit-scopebar` > the input, `div.kit-scopebar-line` (`line`, then
#' `div.kit-scopebar-actions` with `actions`), `div.kit-scopebar-panel` (`panel`). Use
#' `span.kit-scopebar-todo` in `line` for something still to do ("還沒選題庫").
#'
#' @param input The input: usually `shiny::radioButtons(..., inline = TRUE)` (2–5 choices) or
#'   `shiny::selectInput()`.
#' @param line Tags or text for the hint line, for example `"目前：TDCYP 題庫 · 412 題"`. `NULL`
#'   for none. Put dynamic parts in `shiny::uiOutput()` / `shiny::textOutput(inline = TRUE)`.
#' @param actions Small buttons on the right of the hint line ([kit_button()] with the default
#'   kind, [kit_download_button()], `shiny::fileInput()`). A list or a single tag; `NULL` for none.
#' @param panel Optional area under the line for what must be confirmed after choosing (for
#'   example a [kit_checklist()] and buttons, or a `shiny::uiOutput()`). `NULL` for none.
#' @return `<div class="kit-scopebar">`.
#' @examples
#' kit_scope_bar(
#'   shiny::radioButtons("bank", "題庫", c("TDCYP" = "tdcyp", "上傳自己的" = "own"),
#'                       inline = TRUE),
#'   line = "目前：TDCYP 題庫 · 412 題",
#'   actions = list(kit_button("bank_dl", "下載題庫"), kit_button("bank_new", "新增題庫"))
#' )
#' @export
kit_scope_bar <- function(input, line = NULL, actions = NULL, panel = NULL) {
  if (inherits(actions, "shiny.tag")) actions <- list(actions)
  has_actions <- length(actions) > 0
  shiny::tags$div(
    class = "kit-scopebar",
    input,
    if (!is.null(line) || has_actions) {
      shiny::tags$div(
        class = "kit-scopebar-line",
        line,
        if (has_actions) shiny::tags$div(class = "kit-scopebar-actions", actions)
      )
    },
    if (!is.null(panel)) shiny::tags$div(class = "kit-scopebar-panel", panel)
  )
}
