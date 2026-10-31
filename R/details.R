# 細節列、進階設定、設定摘要（Details）

#' Advanced settings: collapsed by default
#'
#' Options in a settings area that are rarely changed (text column matching, ID type conversion,
#' reverse-scored item rules, separators…). A one-line small-print title; when opened, a faint
#' line on the left sets it apart from the other settings (no box).
#'
#' @param ... The settings inside.
#' @param title The collapsible title (can be a tag, e.g. followed by the current settings).
#' @param open Whether it starts open.
#' @param id The id of the `<details>` (used by [kit_open_details()] to open it).
#' @return `<details class="kit-advanced">`.
#' @examples
#' kit_advanced(shiny::checkboxInput("trim", "比對前去掉前後空白", TRUE))  # "Trim spaces before matching"
#' @export
# 原文：進階設定
kit_advanced <- function(..., title = "\u9032\u968e\u8a2d\u5b9a", open = FALSE, id = NULL) {
  shiny::tags$details(
    id = id, class = "kit-advanced", open = if (open) NA,
    shiny::tags$summary(title),
    shiny::tags$div(class = "kit-advanced-body", ...)
  )
}

#' Details row
#'
#' A row of collapsed small-print titles below the result (▸ 預覽 ▸ 這一回合的紀錄 ▸ 用 R 怎麼做;
#' "Preview", "Log for this round", "How to do it in R"). The one that is open takes a full line,
#' and its content has no box. "用 R 怎麼做" ("How to do it in R") always goes last.
#'
#' @param ... [kit_detail()] (or [kit_code_panel()]).
#' @return `<div class="kit-details">`.
#' @examples
#' kit_details_row(
#'   kit_detail("預覽", "前 10 列"),
#'   kit_detail("這一回合的紀錄", "沒有提醒。")
#' )
#' # "Preview" / "First 10 rows"; "Log for this round" / "No notes."
#' @export
kit_details_row <- function(...) {
  shiny::tags$div(class = "kit-details", ...)
}

#' One detail: collapsed by default, a one-line small-print title
#'
#' Outputs inside a collapsed detail are computed only when it is opened: `kit.js` tells Shiny to
#' check again when it opens.
#'
#' @param title The title (a noun: "題目參數" ("Item parameters"), "這一回合的紀錄" ("Log for this
#'   round")).
#' @param ... The content.
#' @param open Whether it starts open.
#' @return `<details class="kit-detail">`.
#' @examples
#' kit_detail("預覽", shiny::tags$p("前 10 列"))  # "Preview", "First 10 rows"
#' @export
kit_detail <- function(title, ..., open = FALSE) {
  shiny::tags$details(
    class = "kit-detail", open = if (open) NA,
    shiny::tags$summary(title),
    shiny::tags$div(class = "kit-detail-body", ...)
  )
}

#' Settings summary: a line of small text above the primary button or the result
#'
#' For example "本次：5 個檔案 · ID：各檔各自 · 全勤樣本" ("This run: 5 files · ID: per file ·
#' complete-attendance sample").
#'
#' @param parts The parts of the text (empty strings, `NA`, and `NULL` are skipped), joined with
#'   " · "; can also be a complete sentence written beforehand (kitsUI's `ui_settings_line(text)`;
#'   in that case use `prefix = NULL`).
#' @param prefix The text in front, default "本次：" ("This run:"); `NULL` adds nothing.
#' @return `<p class="kit-settings-line">`; `NULL` when there are no parts.
#' @examples
#' kit_settings_line(c("5 個檔案", "ID：各檔各自", "全勤樣本"))
#' kit_settings_line("本回合 R1：M03、M36 · 參照世代 M03", prefix = NULL)
#' @export
# 原文：本次：
kit_settings_line <- function(parts, prefix = "\u672c\u6b21\uff1a") {
  parts <- unlist(parts)
  parts <- parts[!is.na(parts) & nzchar(parts)]
  if (length(parts) == 0) return(NULL)
  # 原文： · 
  shiny::tags$p(class = "kit-settings-line", paste0(prefix, paste(parts, collapse = " \u00b7 ")))
}
