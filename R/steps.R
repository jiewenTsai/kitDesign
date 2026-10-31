# 步驟卡（StepCard）與檢查清單（Checklist）
#
# 步驟卡：一頁裡有好幾步、而且有先後時用。一次只打開一步，做完的收成一行
# （圓形 ✓、一句摘要、最右邊「改」），還不能做的是灰的（「先完成第 N 步」）。
# 按「對，下一步」（一般按鈕）才往下；主要按鈕在所有步驟下面，只有一個。
# 一般用模組 kit_stepcards_ui() / kit_stepcards_server()（R/modules.R）；
# 這裡是畫卡片的低階函式。

#' 步驟卡（StepCard）
#'
#' 一張卡片：上面是 [kit_step_head()]（通常由 server 依狀態畫，放 `uiOutput()`），
#' 下面是這一步的內容（[kit_step_body()]，通常包在 `conditionalPanel()` 裡，只有現在這一步打開）。
#' 卡片的框和陰影跟著標頭的狀態：現在這一步有框和陰影；做完和還不能做的沒有陰影、框是灰的。
#'
#' 不想自己管哪一步打開時，用模組 [kit_stepcards_ui()] / [kit_stepcards_server()]。
#'
#' @param head 標頭：[kit_step_head()] 或放它的 `uiOutput()`。
#' @param ... 卡片的內容（[kit_step_body()]）。
#' @param title_id 標頭標題的 id（[kit_step_head()] 的 `title_id`），給螢幕閱讀器當卡片名稱。
#' @return `<section class="kit-stepcard">`。
#' @examples
#' kit_step_card(
#'   kit_step_head(1, "每個檔案是哪個世代、哪個波次", "current", title_id = "steptitle1"),
#'   kit_step_body(shiny::p("已經照欄名猜好了，請看一遍。"),
#'                 shiny::actionButton("ok1", "對，下一步")),
#'   title_id = "steptitle1"
#' )
#' @export
kit_step_card <- function(head, ..., title_id = NULL) {
  shiny::tags$section(class = "kit-stepcard", `aria-labelledby` = title_id, head, ...)
}

#' 步驟卡的標頭
#'
#' 三種狀態：
#'
#' - `"current"`：現在這一步，萊姆色的圓形編號，`aria-current="step"`。
#' - `"done"`：做完的，圓形 ✓（薄荷綠），後面一句摘要，最右邊「改」（有給 `edit_id` 時）。
#' - `"locked"`：還不能做的，灰色，寫「先完成第 N−1 步」。
#'
#' 編號旁邊有給螢幕閱讀器的文字：「第 N 步，現在這一步：」。
#'
#' @param k 第幾步。
#' @param title 這一步的標題。
#' @param state `"current"`、`"done"` 或 `"locked"`。
#' @param summary 做完時的一句摘要（例如「5 個檔案 · 世代 TDCYP · 2009、2011（年）」）。
#'   現在這一步不顯示；還不能做時一律是「先完成第 N−1 步」。
#' @param edit_id 做完時「改」的 `actionLink()` id；`NULL` 不顯示「改」。
#' @param title_id 標題的 id（給 [kit_step_card()] 的 `title_id`）。
#' @return `<div class="kit-stephead is-current">` 等。
#' @examples
#' kit_step_head(1, "每個檔案是哪個世代、哪個波次", "done",
#'               summary = "5 個檔案 · 世代 TDCYP", edit_id = "edit1")
#' kit_step_head(2, "哪些欄是題目", "locked")
#' @export
kit_step_head <- function(k, title, state = c("current", "done", "locked"), summary = NULL,
                          edit_id = NULL, title_id = NULL) {
  state <- match.arg(state)
  # 還不能做的一律寫「先完成第 N−1 步」（和 kitJoin 相同）；摘要只在做完時顯示
  # 原文：先完成第  |  步
  if (state == "locked") summary <- paste0("\u5148\u5b8c\u6210\u7b2c ", k - 1, " \u6b65")
  # 原文：現在這一步 | 做完了 | 還不能做
  said <- c(current = "\u73fe\u5728\u9019\u4e00\u6b65", done = "\u505a\u5b8c\u4e86", locked = "\u9084\u4e0d\u80fd\u505a")[[state]]
  shiny::tags$div(
    class = paste0("kit-stephead is-", state),
    `aria-current` = if (state == "current") "step",
    # 原文：✓
    shiny::tags$span(class = "kit-stepnum", `aria-hidden` = "true", if (state == "done") "\u2713" else k),
    # 原文：第  |  步， | ：
    shiny::tags$span(class = "visually-hidden", paste0("\u7b2c ", k, " \u6b65\uff0c", said, "\uff1a")),
    shiny::tags$span(class = "kit-steptitle", id = title_id, title),
    if (state != "current" && !is.null(summary)) shiny::tags$span(class = "kit-stepsum", summary),
    if (state == "done" && !is.null(edit_id)) {
      # 原文：改
      shiny::actionLink(edit_id, "\u6539", class = "kit-stepedit",
                        # 原文：改第  |  步：
                        `aria-label` = paste0("\u6539\u7b2c ", k, " \u6b65\uff1a", title))
    }
  )
}

#' 步驟卡的內容
#'
#' 卡片裡的表不加外框、淡表頭（CSS 會處理）；手機上不縮排。
#'
#' @param ... 這一步的內容；最後通常是「對，下一步」（`shiny::actionButton()`，一般按鈕）。
#' @return `<div class="kit-stepbody">`。
#' @examples
#' kit_step_body(shiny::p("說明"), shiny::actionButton("ok1", "對，下一步"))
#' @export
kit_step_body <- function(...) {
  shiny::tags$div(class = "kit-stepbody", ...)
}

# 檢查清單的記號與看不見的文字
# 原文：✓
KIT_CHECK_MARK <- c(ok = "\u2713", todo = "!", note = "i")
# 原文：沒問題： | 要決定： | 提醒：
KIT_CHECK_SAID <- c(ok = "\u6c92\u554f\u984c\uff1a", todo = "\u8981\u6c7a\u5b9a\uff1a", note = "\u63d0\u9192\uff1a")

#' 檢查清單的一列（Checklist）
#'
#' 一個 S3 值物件（class `kit_check`）：建構時檢查內容；有 [htmltools::as.tags()] 方法，
#' 直接放進頁面就畫成 `<li class="kit-check">`。通常放進 [kit_checklist()]。
#'
#' 左邊一個記號，前面有看不見的文字（螢幕閱讀器會念）：
#'
#' - `"todo"`：**!** 要決定（「要決定：」）。粗體一句話，下面一行小字說為什麼，再下面是決定的按鈕。
#' - `"ok"`：**✓** 沒問題，或已經決定（「沒問題：」）。字重 500。
#' - `"note"`：**i** 提醒，不用決定（「提醒：」）。
#'
#' 建議的選項放第一個，按鈕上寫「（建議）」。
#'
#' @param state `"todo"`、`"ok"` 或 `"note"`。
#' @param title 一句話（字串）。
#' @param why 下面的小字（為什麼）；`""` 或長度 0 不顯示。（kitJoin 的 `kitsdata_check()` 叫 `text`）
#' @param actions 決定的按鈕（tag 或 tag 的 list）；放在說明下面。
#' @return `kit_check` 物件。
#' @examples
#' kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。")
#' htmltools::as.tags(kit_check("ok", "45 題的分數都是整數"))
#' @export
kit_check <- function(state = c("todo", "ok", "note"), title, why = "", actions = NULL) {
  state <- match.arg(state)
  if (missing(title) || !(is.character(title) && length(title) == 1 && !is.na(title) && nzchar(title))) {
    stop("`title` must be one non-empty string.", call. = FALSE)
  }
  if (is.null(why)) why <- ""
  if (!is.character(why)) stop("`why` must be a character vector.", call. = FALSE)
  if (!is.null(actions) && !kit_is_tagish(actions) &&
      !(is.list(actions) && all(vapply(actions, kit_is_tagish, logical(1))))) {
    stop("`actions` must be a tag, a list of tags, or NULL.", call. = FALSE)
  }
  structure(list(state = state, title = title, why = why, actions = actions), class = "kit_check")
}

#' @rdname kit_check
#' @param x `kit_check` 物件。
#' @param ... 不用。
#' @exportS3Method htmltools::as.tags
as.tags.kit_check <- function(x, ...) {
  shiny::tags$li(
    class = paste("kit-check", x$state),
    shiny::tags$span(class = "kit-check-mark", `aria-hidden` = "true", KIT_CHECK_MARK[[x$state]]),
    shiny::tags$span(class = "visually-hidden", KIT_CHECK_SAID[[x$state]]),
    shiny::tags$div(
      class = "kit-check-text",
      shiny::tags$strong(x$title),
      if (length(x$why) > 0 && any(nzchar(x$why))) shiny::tags$span(paste(x$why, collapse = "")),
      if (length(x$actions) > 0) shiny::tags$div(class = "kit-check-actions", x$actions)
    )
  )
}

#' @rdname kit_check
#' @export
format.kit_check <- function(x, ...) {
  why <- paste(x$why, collapse = "")
  # 原文：（ | ）
  paste0(KIT_CHECK_MARK[[x$state]], " ", x$title, if (nzchar(why)) paste0("\uff08", why, "\uff09"))
}

#' @rdname kit_check
#' @export
print.kit_check <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
  invisible(x)
}

#' 檢查清單（Checklist）
#'
#' 把「要決定的事」和「已經沒問題的事」列在一起，放在轉換或執行之前。
#' 一個 S3 值物件（class `kit_checklist`，[kit_check()] 的 list）：直接放進頁面就畫成
#' `<ul class="kit-checklist">`，一列一件事，列之間一條最淡的線。
#'
#' @param ... [kit_check()]，或它們的 list（`NULL` 略過）。
#' @return `kit_checklist` 物件。
#' @examples
#' cl <- kit_checklist(
#'   kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。",
#'             actions = kit_button("shift", "全部減 1（建議）")),
#'   kit_check("ok", "沒有疑似遺漏值代碼"),
#'   kit_check("note", "有 2 題沒有人作答，不會放進作答檔")
#' )
#' cl
#' htmltools::as.tags(cl)
#' @export
kit_checklist <- function(...) {
  items <- list(...)
  if (length(items) == 1 && is.list(items[[1]]) && !inherits(items[[1]], "kit_check")) {
    items <- unclass(items[[1]])
  }
  items <- Filter(Negate(is.null), items)
  if (!all(vapply(items, inherits, logical(1), what = "kit_check"))) {
    stop("Every item of a checklist must be made with kit_check().", call. = FALSE)
  }
  structure(unname(items), class = "kit_checklist")
}

#' @rdname kit_checklist
#' @param x `kit_checklist` 物件。
#' @exportS3Method htmltools::as.tags
as.tags.kit_checklist <- function(x, ...) {
  shiny::tags$ul(class = "kit-checklist", lapply(unclass(x), htmltools::as.tags))
}

#' @rdname kit_checklist
#' @export
format.kit_checklist <- function(x, ...) {
  if (length(x) == 0) return("<kit_checklist: empty>")
  vapply(unclass(x), format, character(1))
}

#' @rdname kit_checklist
#' @export
print.kit_checklist <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
  invisible(x)
}

#' 表格或清單裡的問題（深橘紅的字）
#'
#' 步驟卡裡「還差：…」或「這幾欄有問題」這類單一問題的清單。
#'
#' @param ... 每個問題一個字串（或 tag）。
#' @param head 前面的粗體字，例如「還差：」；`NULL` 不顯示。
#' @param bullets `TRUE`（預設）每個問題一個項目符號；`FALSE` 一行一個、不加符號
#'   （例如每一行已經是完整的句子，或前面自己有編號）。
#' @return `<div class="kit-problems">`；沒有問題時是 `NULL`。
#' @examples
#' kit_problems("第 2 列沒有選世代", "第 4 列的波次不是數字", head = "還差：")
#' kit_problems("bsrs1：w1d5_1 和 w2d5_1 的分數範圍不同", bullets = FALSE)
#' @export
kit_problems <- function(..., head = NULL, bullets = TRUE) {
  items <- c(...)
  if (length(items) == 0) return(NULL)
  shiny::tags$div(
    class = "kit-problems",
    if (!is.null(head)) shiny::tags$strong(head),
    if (isTRUE(bullets)) {
      shiny::tags$ul(lapply(items, shiny::tags$li))
    } else {
      lapply(items, shiny::tags$div)
    }
  )
}
