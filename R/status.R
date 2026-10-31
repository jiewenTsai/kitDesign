# 狀態框（StatusBox）與給使用者看的錯誤
#
# KIT 設計語言 StatusBox：按了主要按鈕以後第一眼看的框，只有四種標籤。
# 第一行是標籤＋一句結論（帶數字與單位）；接著最多 3 點要注意的事；
# 停下來時寫怎麼辦，原始的錯誤訊息收在「原始訊息」裡。
#
# kit_status 是一個 S3 值物件：建構時檢查內容；有 htmltools::as.tags() 方法，
# 所以 renderUI(st) 或直接放進 tagList() 就會畫成狀態框。

# 狀態 → 框的顏色與標籤（idle 不顯示）
KIT_STATUS_LOOK <- list(
  # 原文：【完成】
  success = c(class = "alert-success", label = "\u3010\u5b8c\u6210\u3011"),
  # 原文：【完成，但請注意】
  warning = c(class = "alert-warning", label = "\u3010\u5b8c\u6210\uff0c\u4f46\u8acb\u6ce8\u610f\u3011"),
  # 原文：【停下來】
  error = c(class = "alert-danger", label = "\u3010\u505c\u4e0b\u4f86\u3011"),
  # 原文：【要重新執行】
  stale = c(class = "alert-warning", label = "\u3010\u8981\u91cd\u65b0\u57f7\u884c\u3011")
)

# 可以用的狀態
KIT_STATUS_STATES <- c("idle", "success", "warning", "error", "stale")

# kitsUI 的 ui_status() 用的名字
KIT_STATUS_ALIAS <- c(done = "success", warn = "warning", stop = "error")

# 狀態框裡直接列出幾點；更多的收在「還有 N 點」裡
KIT_STATUS_MAX_POINTS <- 3L

# 通知訊息顯示秒數
KIT_NOTIFY_SECONDS <- 6
KIT_NOTIFY_ERROR_SECONDS <- 10

#' Normalize a state name (kitsUI's done/warn/stop become success/warning/error)
#' @noRd
kit_state_name <- function(state) {
  if (is.null(state) || length(state) == 0) return("idle")
  state <- as.character(state[[1]])
  if (state %in% names(KIT_STATUS_ALIAS)) state <- KIT_STATUS_ALIAS[[state]]
  state
}

#' Is it a tag, tagList, or HTML?
#' @noRd
kit_is_tagish <- function(x) {
  inherits(x, c("shiny.tag", "shiny.tag.list", "html"))
}

#' A set of texts or tags (points, notes): a character vector, or a list of strings and tags
#' @noRd
kit_check_items <- function(x, arg) {
  if (is.null(x) || length(x) == 0) return(character(0))
  if (is.character(x)) return(x)
  if (kit_is_tagish(x)) return(list(x))
  if (is.list(x)) {
    ok <- vapply(x, function(v) (is.character(v) && length(v) == 1) || kit_is_tagish(v), logical(1))
    if (all(ok)) return(x)
  }
  stop("`", arg, "` must be a character vector or a list of strings and tags.", call. = FALSE)
}

#' Status object (status box)
#'
#' The result of an action. This is an S3 value object (class `kit_status`): its content is checked
#' when it is built. It has an [htmltools::as.tags()] method, so `renderUI(st)` or putting it straight
#' into `tagList()` renders it as a status box (the same as [kit_status_ui()]). `print(st)` prints a
#' text version.
#'
#' Each of the four states has a fixed label and color:
#'
#' | state | Label | Background |
#' |---|---|---|
#' | `"success"` | 【完成】 ("Done") | mint green |
#' | `"warning"` | 【完成，但請注意】 ("Done, but please note") | yellow |
#' | `"error"` | 【停下來】 ("Stopped") | salmon |
#' | `"stale"` | 【要重新執行】 ("Run again") | yellow |
#'
#' `"idle"` (not run yet) is not shown. kitsUI's names are also accepted: `"done"`, `"warn"`, `"stop"`.
#'
#' @param state `"idle"`, `"success"`, `"warning"`, `"error"`, or `"stale"`.
#' @param message The conclusion on the first line (one sentence, with numbers and units): a string or
#'   tag.
#' @param warnings Things to watch out for (a character vector, or a list of strings and tags). Listed
#'   first.
#' @param notes Additional notes (small gray text).
#' @param details The raw message (R's original error text; collapsed): a string or `NULL`.
#' @param action A button or link for what to do (a tag); `NULL` shows nothing.
#' @param points Key results (listed after `warnings`; they do not turn the status into "請注意",
#'   "please note").
#' @param details_title The collapsible title for the raw message (kitsUI uses "kits 的原文", "kits'
#'   original text").
#' @return A `kit_status` object.
#' @seealso [kit_status_ui()], [kit_done_status()], [kit_error_status()], [kit_stale_status()]
#' @examples
#' st <- kit_status("success", "串接完成：結果共 3,389 列 × 2,058 欄。")
#' st
#' htmltools::as.tags(st)
#' @export
kit_status <- function(state = "idle", message = "", warnings = character(0),
                       notes = character(0), details = NULL, action = NULL,
                       # 原文：原始訊息
                       points = character(0), details_title = "\u539f\u59cb\u8a0a\u606f") {
  state <- kit_state_name(state)
  if (!state %in% KIT_STATUS_STATES) {
    stop("`state` must be one of ", paste(KIT_STATUS_STATES, collapse = ", "),
         " (or done, warn, stop), not \"", state, "\".", call. = FALSE)
  }
  if (!(kit_is_tagish(message) || (is.character(message) && length(message) == 1 && !is.na(message)))) {
    stop("`message` must be one string or a tag.", call. = FALSE)
  }
  if (!is.null(details) && !(is.character(details) && length(details) <= 1)) {
    stop("`details` must be one string or NULL.", call. = FALSE)
  }
  if (!is.null(action) && !kit_is_tagish(action)) {
    stop("`action` must be a tag (a button or link) or NULL.", call. = FALSE)
  }
  if (!(is.character(details_title) && length(details_title) == 1)) {
    stop("`details_title` must be one string.", call. = FALSE)
  }
  structure(
    list(
      state = state,
      message = message,
      warnings = kit_check_items(warnings, "warnings"),
      notes = kit_check_items(notes, "notes"),
      details = details,
      action = action,
      points = kit_check_items(points, "points"),
      details_title = details_title
    ),
    class = "kit_status"
  )
}

#' Status after a run: 【完成，但請注意】 (done, but take note) when something needs attention,
#' otherwise 【完成】 (done)
#'
#' Anything unusual must be seen: when there are `warnings`, the status cannot be a plain 【完成】
#' (done).
#'
#' @inheritParams kit_status
#' @return A `kit_status` object.
#' @examples
#' kit_done_status("串接完成：3,389 人。")  # "Join done: 3,389 children."
#' kit_done_status("串接完成：3,389 人。", warnings = "有 12 人的 ID 重複，只留第一筆。")
#' # warning: "12 children have duplicate IDs; only the first record is kept."
#' @export
kit_done_status <- function(message, warnings = character(0), notes = character(0),
                            points = character(0)) {
  state <- if (length(warnings) > 0) "warning" else "success"
  kit_status(state, message, warnings = warnings, notes = notes, points = points)
}

#' Status for a failed run (【停下來】, stopped)
#'
#' Plain-language errors from [kit_abort()] are shown directly; for unexpected errors it says what to
#' do, and the original message is tucked inside "原始訊息" ("Original message").
#'
#' @param e The error (a condition).
#' @param action The action name, e.g. "串接" ("join").
#' @param todo A button or link for what to do (a tag); `NULL` shows nothing.
#' @return A `kit_status` object.
#' @examples
#' e <- tryCatch(stop("object 'x' not found"), error = identity)
#' kit_error_status(e, "串接")
#' u <- tryCatch(kit_abort("至少要 2 個波次的檔案。"), error = identity)  # "Need files from at least 2 waves."
#' kit_error_status(u, "串接")$message
#' @export
kit_error_status <- function(e, action, todo = NULL) {
  if (inherits(e, "kit_user_error")) {
    return(kit_status("error", conditionMessage(e), action = todo))
  }
  kit_status(
    "error",
    # 原文：時發生沒有預期到的問題，沒有做完。
    paste0(action, "\u6642\u767c\u751f\u6c92\u6709\u9810\u671f\u5230\u7684\u554f\u984c\uff0c\u6c92\u6709\u505a\u5b8c\u3002"),
    warnings = paste0(
      # 原文：怎麼辦：確認檔案內容與設定後再試一次；一直發生的話，
      "\u600e\u9ebc\u8fa6\uff1a\u78ba\u8a8d\u6a94\u6848\u5167\u5bb9\u8207\u8a2d\u5b9a\u5f8c\u518d\u8a66\u4e00\u6b21\uff1b\u4e00\u76f4\u767c\u751f\u7684\u8a71\uff0c",
      # 原文：請把下面的「原始訊息」回報給開發者。
      "\u8acb\u628a\u4e0b\u9762\u7684\u300c\u539f\u59cb\u8a0a\u606f\u300d\u56de\u5831\u7d66\u958b\u767c\u8005\u3002"
    ),
    details = conditionMessage(e),
    action = todo
  )
}

#' Old result no longer valid after files or settings change (【要重新執行】, "Run again")
#'
#' @param run_label The primary button's text, for example "執行串接" ("Run join").
#' @param message Your own sentence (the default is "檔案或設定改過了，舊的結果已清除：請再按一次「…」。",
#'   "Files or settings changed and the old result was cleared: press '…' again.").
#' @return A `kit_status` object.
#' @examples
#' kit_stale_status("執行串接")$message
#' @export
kit_stale_status <- function(run_label, message = NULL) {
  kit_status(
    "stale",
    # 原文：檔案或設定改過了，舊的結果已清除：請再按一次「 | 」。
    message %||% paste0("\u6a94\u6848\u6216\u8a2d\u5b9a\u6539\u904e\u4e86\uff0c\u820a\u7684\u7d50\u679c\u5df2\u6e05\u9664\uff1a\u8acb\u518d\u6309\u4e00\u6b21\u300c", run_label, "\u300d\u3002")
  )
}

#' Status box
#'
#' Renders a [kit_status()] as a status box: the first line is the label plus a one-sentence
#' conclusion; then up to 3 points (things to watch out for first, key results after), the rest
#' collapsed under "還有 N 點" ("N more points"); a button for what to do; small additional notes; the
#' collapsed raw message. After running, use [kit_scroll_to()] to scroll it to the top of the screen.
#'
#' A `kit_status` object can also go straight into the page (its [htmltools::as.tags()] method is this
#' function); you only need to call this function to add more content or change the number of points.
#'
#' @param st A [kit_status()] object (a list with the same fields, from older apps, also works); `NULL`
#'   or `"idle"` shows nothing.
#' @param ... Other content placed last inside the box (kitsUI's `ui_status(...)`).
#' @param max_points How many points to list directly (default 3).
#' @return `<div class="alert alert-success kit-status" role="alert">` or similar; `NULL` when nothing
#'   is shown.
#' @examples
#' kit_status_ui(kit_done_status(
#'   "串接完成：結果共 3,389 列 × 2,058 欄。",
#'   warnings = c("有 12 人的 ID 重複。", "第 3 波沒有 sex 欄。"),
#'   points = c("688 人每個檔案都有資料。", "第 1 波 3,389 人。")
#' ))
#' @export
kit_status_ui <- function(st, ..., max_points = KIT_STATUS_MAX_POINTS) {
  if (is.null(st)) return(NULL)
  state <- kit_state_name(st$state)
  if (identical(state, "idle")) return(NULL)
  look <- KIT_STATUS_LOOK[[state]]
  if (is.null(look)) stop("Unknown status state: ", state, call. = FALSE)
  # 要注意的事在前，結果的重點在後；直接列 3 點，其他收進「還有 N 點」
  as_items <- function(x) {
    if (length(x) == 0) return(list())
    if (inherits(x, "shiny.tag")) return(list(x))
    if (is.list(x)) x else as.list(x)
  }
  points <- c(as_items(st$warnings), as_items(st$points))
  shown <- utils::head(points, max_points)
  more <- points[-seq_along(shown)]
  shiny::tags$div(
    class = paste("alert", look[["class"]], "kit-status"),
    role = "alert",
    shiny::tags$div(
      class = "kit-status-line",
      shiny::tags$strong(look[["label"]]), " ", st$message
    ),
    if (length(shown) > 0) shiny::tags$ul(lapply(shown, shiny::tags$li)),
    if (length(more) > 0) {
      shiny::tags$details(
        class = "kit-status-more",
        # 原文：還有  |  點
        shiny::tags$summary(paste0("\u9084\u6709 ", kit_num(length(more)), " \u9ede")),
        shiny::tags$ul(lapply(more, shiny::tags$li))
      )
    },
    if (!is.null(st$action)) shiny::tags$div(class = "kit-status-action", st$action),
    if (length(st$notes) > 0) {
      shiny::tags$div(
        class = "kit-status-notes",
        lapply(st$notes, shiny::tags$div)
      )
    },
    if (!is.null(st$details) && length(st$details) > 0 && any(nzchar(st$details))) {
      shiny::tags$details(
        class = "kit-status-raw",
        # 原文：原始訊息
        shiny::tags$summary(st$details_title %||% "\u539f\u59cb\u8a0a\u606f"),
        shiny::tags$code(st$details)
      )
    },
    ...
  )
}

#' @rdname kit_status
#' @param x A `kit_status` object.
#' @param ... Other content for [kit_status_ui()] (as.tags); not used by format and print.
#' @exportS3Method htmltools::as.tags
as.tags.kit_status <- function(x, ...) {
  kit_status_ui(x, ...) %||% htmltools::tagList()
}

#' Text version of a piece of content (a tag becomes plain text)
#' @noRd
kit_plain <- function(x) {
  if (kit_is_tagish(x)) return(gsub("\\s+", " ", trimws(gsub("<[^>]+>", " ", as.character(x)))))
  paste(as.character(x), collapse = "")
}

#' @rdname kit_status
#' @export
format.kit_status <- function(x, ...) {
  if (identical(x$state, "idle")) return("<kit_status: idle>")
  points <- c(as.list(x$warnings), as.list(x$points))
  c(
    paste0(KIT_STATUS_LOOK[[x$state]][["label"]], " ", kit_plain(x$message)),
    if (length(points) > 0) paste0("- ", vapply(points, kit_plain, character(1))),
    if (length(x$notes) > 0) paste0("  ", vapply(as.list(x$notes), kit_plain, character(1))),
    # 原文：：
    if (!is.null(x$details)) paste0("  ", x$details_title, "\uff1a", x$details)
  )
}

#' @rdname kit_status
#' @export
print.kit_status <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
  invisible(x)
}

#' Show a notification (Shiny's showNotification)
#'
#' 【停下來】 (stopped) is red and shows for 10 seconds; everything else uses the regular style and
#' shows for 6 seconds.
#'
#' @param st A [kit_status()] object, or a string (a plain notification).
#' @param session The Shiny session (defaults to the current session).
#' @param duration How many seconds to show it; when `NULL`, the defaults above apply.
#' @return The notification id (invisible); `NULL` for `"idle"` or when there is no session.
#' @examples
#' if (interactive()) {
#'   kit_notify(kit_done_status("串接完成。"))  # "Join done."
#' }
#' @export
kit_notify <- function(st, session = shiny::getDefaultReactiveDomain(), duration = NULL) {
  if (is.character(st)) st <- kit_status("success", st)
  state <- kit_state_name(st$state)
  if (identical(state, "idle") || is.null(session)) return(invisible(NULL))
  err <- identical(state, "error")
  invisible(shiny::showNotification(
    kit_plain(st$message),
    type = if (err) "error" else "message",
    duration = duration %||% if (err) KIT_NOTIFY_ERROR_SECONDS else KIT_NOTIFY_SECONDS,
    session = session
  ))
}

#' An error meant for the user
#'
#' The message should be plain-language Chinese that says what went wrong and how to fix it;
#' [kit_error_status()] shows it as written in the status box, with no technical details. Any other,
#' unexpected error is wrapped as "…時發生沒有預期到的問題" ("an unexpected problem occurred while …"),
#' with the original message tucked away.
#'
#' @param ... The message (joined with `paste0()`).
#' @param class An extra condition class (the caller can handle it separately, e.g. to show a
#'   confirmation dialog).
#' @param data Other fields to attach to the condition (a named list).
#' @return Does not return: throws a `kit_user_error` error.
#' @examples
#' e <- tryCatch(kit_abort("至少要 ", 2, " 個波次的檔案。"), error = identity)  # "Need files from at least 2 waves."
#' class(e)
#' conditionMessage(e)
#' @export
kit_abort <- function(..., class = NULL, data = list()) {
  stop(structure(
    class = c(class, "kit_user_error", "error", "condition"),
    c(list(message = paste0(...), call = NULL), data)
  ))
}

#' Was the error thrown by [kit_abort()]?
#'
#' @param e The error (a condition).
#' @return `TRUE` or `FALSE`.
#' @examples
#' kit_is_user_error(tryCatch(kit_abort("x"), error = identity))
#' @export
kit_is_user_error <- function(e) inherits(e, "kit_user_error")
