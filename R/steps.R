# 步驟卡（StepCard）與檢查清單（Checklist）
#
# 步驟卡：一頁裡有好幾步、而且有先後時用。一次只打開一步，做完的收成一行
# （圓形 ✓、一句摘要、最右邊「改」），還不能做的是灰的（「先完成第 N 步」）。
# 按「對，下一步」（一般按鈕）才往下；主要按鈕在所有步驟下面，只有一個。
# 一般用模組 kit_stepcards_ui() / kit_stepcards_server()（R/modules.R）；
# 這裡是畫卡片的低階函式。

#' Step card
#'
#' One card: on top is [kit_step_head()] (usually rendered by the server based on the state, in a
#' `uiOutput()`), below is the content of this step ([kit_step_body()], usually wrapped in
#' `conditionalPanel()` so only the current step is open). The card's border and shadow follow the
#' header's state: the current step has a border and shadow; finished steps and steps not yet
#' available have no shadow and a gray border.
#'
#' If you do not want to manage which step is open yourself, use the module [kit_stepcards_ui()] /
#' [kit_stepcards_server()].
#'
#' @param head The header: [kit_step_head()], or the `uiOutput()` that holds it.
#' @param ... The card content ([kit_step_body()]).
#' @param title_id The id of the header title (the `title_id` of [kit_step_head()]), used by screen
#'   readers as the card name.
#' @return `<section class="kit-stepcard">`.
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

#' Step card header
#'
#' Three states:
#'
#' - `"current"`: the current step, a lime round number, `aria-current="step"`.
#' - `"done"`: finished, a round ✓ (mint green), followed by a one-sentence summary, with "改"
#'   ("Edit") at the far right (when `edit_id` is given).
#' - `"locked"`: not yet available, gray, showing "先完成第 N−1 步" ("Finish step N−1 first").
#'
#' Next to the number there is text for screen readers: "第 N 步，現在這一步：" ("Step N, current
#' step:").
#'
#' @param k The step number.
#' @param title The title of this step.
#' @param state `"current"`, `"done"`, or `"locked"`.
#' @param summary A one-sentence summary shown when done (for example "5 個檔案 · 世代 TDCYP ·
#'   2009、2011（年）", "5 files · cohort TDCYP · 2009, 2011 (year)"). Not shown for the current step;
#'   a step not yet available always shows "先完成第 N−1 步" ("Finish step N−1 first").
#' @param edit_id The `actionLink()` id for "改" ("Edit") when done; `NULL` hides "改".
#' @param title_id The id of the title (pass it to the `title_id` of [kit_step_card()]).
#' @return `<div class="kit-stephead is-current">` or similar.
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

#' Step card content
#'
#' Tables inside the card have no outer border and a light header (CSS handles this); no indent on
#' phones.
#'
#' @param ... The content of this step; usually ends with "對，下一步" ("Yes, next step")
#'   (`shiny::actionButton()`, a regular button).
#' @return `<div class="kit-stepbody">`.
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

#' One checklist row
#'
#' An S3 value object (class `kit_check`): its content is checked when it is built; it has an
#' [htmltools::as.tags()] method, so putting it straight into a page renders `<li class="kit-check">`.
#' Usually placed inside [kit_checklist()].
#'
#' A mark on the left, preceded by hidden text (read by screen readers):
#'
#' - `"todo"`: **!** needs a decision ("要決定：", "To decide:"). One bold sentence, a line of small
#'   print below saying why, and the decision buttons below that.
#' - `"ok"`: **✓** fine, or already decided ("沒問題：", "OK:"). Font weight 500.
#' - `"note"`: **i** a reminder, no decision needed ("提醒：", "Note:").
#'
#' Put the recommended option first and write "（建議）" ("(recommended)") on its button.
#'
#' @param state `"todo"`, `"ok"`, or `"note"`.
#' @param title One sentence (a string).
#' @param why The small print below (why); `""` or length 0 shows nothing. (kitJoin's
#'   `kitsdata_check()` calls it `text`.)
#' @param actions Buttons for the decision (a tag or list of tags); placed below the explanation.
#' @return A `kit_check` object.
#' @examples
#' kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。")
#' # "3 items have scores starting at 1" / "kits needs scores 0, 1, 2…"
#' htmltools::as.tags(kit_check("ok", "45 題的分數都是整數"))  # "All 45 items have integer scores"
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
#' @param x A `kit_check` object.
#' @param ... Not used.
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

#' Checklist
#'
#' Lists "things to decide" together with "things already fine", placed before a conversion or run.
#' An S3 value object (class `kit_checklist`, a list of [kit_check()]): put it straight into a page and
#' it renders as `<ul class="kit-checklist">`, one item per row, with the faintest line between rows.
#'
#' @param ... [kit_check()] items, or a list of them (`NULL` is skipped).
#' @return A `kit_checklist` object.
#' @examples
#' cl <- kit_checklist(
#'   kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。",
#'             actions = kit_button("shift", "全部減 1（建議）")),
#'   kit_check("ok", "沒有疑似遺漏值代碼"),
#'   kit_check("note", "有 2 題沒有人作答，不會放進作答檔")
#' )
#' # todo: "3 items have scores starting at 1" / "kits needs scores 0, 1, 2…" / button "Subtract 1 from all (recommended)"
#' # ok:   "No suspected missing-value codes"
#' # note: "2 items have no responses and will not go into the response file"
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
#' @param x A `kit_checklist` object.
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

#' Problems in a table or list (dark orange-red text)
#'
#' A list of individual problems inside a step card, such as "還差：…" ("Still needed: …") or
#' "這幾欄有問題" ("these columns have problems").
#'
#' @param ... One string (or tag) per problem.
#' @param head Bold text in front, for example "還差：" ("Still needed:"); `NULL` shows nothing.
#' @param bullets `TRUE` (default): one bullet per problem; `FALSE`: one per line, without bullets
#'   (for example when each line is already a full sentence, or already has its own numbering).
#' @return `<div class="kit-problems">`; `NULL` when there are no problems.
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
