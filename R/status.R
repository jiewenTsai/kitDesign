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

#' 統一狀態名稱（kitsUI 的 done／warn／stop 換成 success／warning／error）
#' @noRd
kit_state_name <- function(state) {
  if (is.null(state) || length(state) == 0) return("idle")
  state <- as.character(state[[1]])
  if (state %in% names(KIT_STATUS_ALIAS)) state <- KIT_STATUS_ALIAS[[state]]
  state
}

#' 是不是 tag、tagList 或 HTML
#' @noRd
kit_is_tagish <- function(x) {
  inherits(x, c("shiny.tag", "shiny.tag.list", "html"))
}

#' 一串文字或 tag（條列、補充）：字串向量，或字串與 tag 的 list
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

#' 狀態物件（StatusBox）
#'
#' 一個動作的結果。這是一個 S3 值物件（class `kit_status`）：建構時檢查內容；
#' 有 [htmltools::as.tags()] 方法，所以 `renderUI(st)` 或直接放進 `tagList()` 就會畫成狀態框
#' （和 [kit_status_ui()] 一樣）。`print(st)` 印出文字版。
#'
#' 四種狀態各有固定的標籤與顏色：
#'
#' | state | 標籤 | 底色 |
#' |---|---|---|
#' | `"success"` | 【完成】 | 薄荷綠 |
#' | `"warning"` | 【完成，但請注意】 | 黃 |
#' | `"error"` | 【停下來】 | 鮭紅 |
#' | `"stale"` | 【要重新執行】 | 黃 |
#'
#' `"idle"`（還沒有執行）不顯示。也接受 kitsUI 的名字：`"done"`、`"warn"`、`"stop"`。
#'
#' @param state `"idle"`、`"success"`、`"warning"`、`"error"` 或 `"stale"`。
#' @param message 第一行的結論（一句話，帶數字與單位）：一個字串或 tag。
#' @param warnings 需要注意的事（字串向量，或字串與 tag 的 list）。排在最前面。
#' @param notes 補充說明（灰色小字）。
#' @param details 原始訊息（R 的錯誤原文；收起來）：一個字串或 `NULL`。
#' @param action 怎麼辦的按鈕或連結（tag）；`NULL` 不顯示。
#' @param points 結果的重點（排在 `warnings` 後面；不會讓狀態變成「請注意」）。
#' @param details_title 原始訊息的收合標題（kitsUI 用「kits 的原文」）。
#' @return `kit_status` 物件。
#' @seealso [kit_status_ui()]、[kit_done_status()]、[kit_error_status()]、[kit_stale_status()]
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

#' 執行完的狀態：有要注意的事時是【完成，但請注意】，否則是【完成】
#'
#' 異常一定要被看見：有 `warnings` 時，狀態就不能是單純的【完成】。
#'
#' @inheritParams kit_status
#' @return `kit_status` 物件。
#' @examples
#' kit_done_status("串接完成：3,389 人。")
#' kit_done_status("串接完成：3,389 人。", warnings = "有 12 人的 ID 重複，只留第一筆。")
#' @export
kit_done_status <- function(message, warnings = character(0), notes = character(0),
                            points = character(0)) {
  state <- if (length(warnings) > 0) "warning" else "success"
  kit_status(state, message, warnings = warnings, notes = notes, points = points)
}

#' 執行失敗的狀態（【停下來】）
#'
#' [kit_abort()] 的白話錯誤直接顯示；沒有預期到的錯誤寫「怎麼辦」，
#' 原始訊息收在「原始訊息」裡。
#'
#' @param e 錯誤（condition）。
#' @param action 動作名稱，例如「串接」。
#' @param todo 怎麼辦的按鈕或連結（tag）；`NULL` 不顯示。
#' @return `kit_status` 物件。
#' @examples
#' e <- tryCatch(stop("object 'x' not found"), error = identity)
#' kit_error_status(e, "串接")
#' u <- tryCatch(kit_abort("至少要 2 個波次的檔案。"), error = identity)
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

#' 檔案或設定變更後，舊結果失效（【要重新執行】）
#'
#' @param run_label 主要按鈕的字，例如「執行串接」。
#' @param message 自己寫的一句話（預設是「檔案或設定改過了，舊的結果已清除：請再按一次「…」。」）。
#' @return `kit_status` 物件。
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

#' 狀態框（StatusBox）
#'
#' 把 [kit_status()] 畫成狀態框：第一行是標籤＋一句結論；接著最多 3 點
#' （要注意的事在前、結果的重點在後），其他收在「還有 N 點」；怎麼辦的按鈕；
#' 補充小字；收起來的原始訊息。執行完用 [kit_scroll_to()] 把它捲到畫面上方。
#'
#' `kit_status` 物件直接放進頁面也可以（[htmltools::as.tags()] 方法就是這個函式）；
#' 要多放東西或改點數時才需要呼叫它。
#'
#' @param st [kit_status()] 物件（舊的 app 的同樣欄位的 list 也可以）；`NULL` 或 `"idle"` 時不顯示。
#' @param ... 其他放在框裡最後的內容（kitsUI 的 `ui_status(...)`）。
#' @param max_points 直接列出幾點（預設 3）。
#' @return `<div class="alert alert-success kit-status" role="alert">` 等；不顯示時是 `NULL`。
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
#' @param x `kit_status` 物件。
#' @param ... 給 [kit_status_ui()] 的其他內容（as.tags）；format、print 不用。
#' @exportS3Method htmltools::as.tags
as.tags.kit_status <- function(x, ...) {
  kit_status_ui(x, ...) %||% htmltools::tagList()
}

#' 文字版的一段文字（tag 轉成純文字）
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

#' 顯示通知（Shiny 的 showNotification）
#'
#' 【停下來】用紅色、顯示 10 秒；其他用一般樣式、顯示 6 秒。
#'
#' @param st [kit_status()] 物件，或一個字串（一般通知）。
#' @param session Shiny session（預設是目前的 session）。
#' @param duration 顯示幾秒；`NULL` 時照上面的預設。
#' @return 通知的 id（不可見）；`"idle"` 或沒有 session 時是 `NULL`。
#' @examples
#' if (interactive()) {
#'   kit_notify(kit_done_status("串接完成。"))
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

#' 給使用者看的錯誤
#'
#' 訊息要是白話中文、說明原因與怎麼修；[kit_error_status()] 會原文顯示在狀態框，
#' 不加技術細節。其他沒有預期到的錯誤則包成「…時發生沒有預期到的問題」，
#' 原始訊息收起來。
#'
#' @param ... 訊息（用 `paste0()` 接起來）。
#' @param class 另外加的 condition class（呼叫端可以另外處理，例如跳出確認視窗）。
#' @param data 附在 condition 上的其他欄位（具名 list）。
#' @return 不會回傳：丟出 `kit_user_error` 錯誤。
#' @examples
#' e <- tryCatch(kit_abort("至少要 ", 2, " 個波次的檔案。"), error = identity)
#' class(e)
#' conditionMessage(e)
#' @export
kit_abort <- function(..., class = NULL, data = list()) {
  stop(structure(
    class = c(class, "kit_user_error", "error", "condition"),
    c(list(message = paste0(...), call = NULL), data)
  ))
}

#' 是不是 [kit_abort()] 丟出的錯誤
#'
#' @param e 錯誤（condition）。
#' @return `TRUE` 或 `FALSE`。
#' @examples
#' kit_is_user_error(tryCatch(kit_abort("x"), error = identity))
#' @export
kit_is_user_error <- function(e) inherits(e, "kit_user_error")
