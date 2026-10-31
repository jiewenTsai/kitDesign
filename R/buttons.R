# 按鈕、提示框、下一步、連到別的 app

# 按鈕的寫法（KIT 設計語言 Button）：主要按鈕一頁一個（加上最下面的「下一步」）；
# 次要按鈕（下載、全選、上移…）白底、小一號；危險按鈕（移除、這一回合不做）鮭紅底
KIT_BTN <- c(
  primary = "btn-primary",
  secondary = "btn-sm btn-outline-secondary",
  danger = "btn-sm btn-danger"
)

#' Class for a button kind
#'
#' When you build a button yourself (e.g. `downloadButton()`, `<a class="btn">`), use this class
#' so it looks the same as [kit_button()].
#'
#' @param kind `"primary"` (primary button), `"secondary"` (secondary button), or `"danger"`
#'   (danger button).
#' @return A class string, e.g. `"btn-sm btn-outline-secondary"`.
#' @examples
#' kit_btn_class("secondary")
#' @export
kit_btn_class <- function(kind = c("secondary", "primary", "danger")) {
  kind <- match.arg(kind)
  unname(KIT_BTN[[kind]])
}

#' Button
#'
#' A [shiny::actionButton()] with a class set by the button kind:
#'
#' - `"primary"`: primary button, lime background, large text, card shadow. One per page, plus the
#'   "下一步" ("Next step") at the bottom.
#' - `"secondary"`: secondary button, white background, thin border, no shadow. For download,
#'   select all, example files, move up/down, copy.
#' - `"danger"`: danger button, salmon background. For delete, remove, skip this round.
#'
#' For a regular button (white background, black border, small shadow, e.g. "對，下一步" ("Yes,
#' next step")) use `shiny::actionButton()` directly.
#' Start the text with a verb and say clearly what pressing it does; if it leaves the page, add
#' "→" after the text.
#'
#' @param id The button's input id.
#' @param label The text on the button.
#' @param kind `"primary"`, `"secondary"`, or `"danger"`.
#' @param ... Other arguments passed to [shiny::actionButton()] (e.g. `disabled = TRUE`, `icon`).
#' @param class An extra class.
#' @return `<button class="btn ...">`.
#' @examples
#' kit_button("run", "執行串接", "primary")       # "Run join"
#' kit_button("all", "全選")                     # "Select all"
#' kit_button("drop", "這一回合不做", "danger")  # "Skip this round"
#' @export
kit_button <- function(id, label, kind = "secondary", ..., class = NULL) {
  shiny::actionButton(id, label, class = paste(c(KIT_BTN[[kind]], class), collapse = " "), ...)
}

#' Callout
#'
#' A reminder the user should know before pressing a button. It is not a result, so it has no
#' shadow. At most one per section; if it can go in the status box, don't add a separate callout;
#' if there is a button, put the button outside the box.
#'
#' @param ... The content of the box.
#' @param warn `FALSE`: sky-blue info; `TRUE`: yellow caution.
#' @param class An extra class.
#' @return `<div class="kit-callout">` (plus `kit-callout-warn` for caution).
#' @examples
#' kit_callout("外部連結不適用：這一回合只有一個世代，這不是錯誤。")
#' # "External linking does not apply: this round has only one cohort. This is not an error."
#' kit_callout("資料裡有疑似遺漏值代碼，建議先到「遺漏值處理」。", warn = TRUE)
#' # "The data seem to contain missing-value codes; go to 'Missing values' first."
#' @export
kit_callout <- function(..., warn = FALSE, class = NULL) {
  shiny::tags$div(
    class = paste(c("kit-callout", if (warn) "kit-callout-warn", class), collapse = " "),
    ...
  )
}

#' Next step
#'
#' At the bottom of the page, aligned right: a line of small text on the left (it can be a list of
#' places to go next), and a button on the right, "下一步：××× →" ("Next step: ××× →"). Shown
#' only after a result is ready (【完成】 done, or 【完成，但請注意】 done, but take note);
#' removed when the result is out of date (【要重新執行】, needs a rerun).
#'
#' @param text Small text on the left; `NULL` shows nothing.
#' @param button_id The button id; when `NULL` no button is drawn (unless `button` is given).
#' @param label The button text, e.g. "下一步：橫向資料串接" ("Next step: wide join"); " →" is
#'   added automatically.
#' @param button A button to use directly instead of an actionButton (e.g. a link to another app).
#' @param kind The button kind: primary button by default; use `"secondary"` when the page already
#'   has another main action (e.g. a download).
#' @return `<div class="kit-next">`.
#' @examples
#' kit_next_step("串接好了，可以接著做 kits 作答檔。", "next", "下一步：kits 作答檔")
#' # "Join done; you can go on to the kits response file." / "Next step: kits response file"
#' @export
kit_next_step <- function(text = NULL, button_id = NULL, label = NULL, button = NULL,
                          kind = "primary") {
  if (is.null(button) && !is.null(button_id)) {
    # 原文： →
    button <- kit_button(button_id, paste0(label, " \u2192"), kind)
  }
  shiny::tags$div(
    class = "kit-next",
    if (!is.null(text)) shiny::tags$div(class = "kit-hint", text),
    button
  )
}

#' A link to another website or app (opens in a new tab)
#'
#' For example, a link from kitJoin to the cloud version of kitsUI. The link opens in a new tab
#' (`target="_blank"`) and can be followed by a line of small print saying where it goes.
#' Whether to show the link (local version, cloud version) is up to the app.
#'
#' @param label The link text, e.g. "開啟 kitsUI" ("Open kitsUI").
#' @param href The URL.
#' @param kind `"link"` (a text link) or a button kind (`"secondary"`, `"primary"`).
#' @param class An extra class for the link (e.g. `"kit-next-link"`).
#' @param note A line of small print after it, e.g. "（開啟網路上的雲端版 kitsUI）" ("(opens the
#'   online cloud version of kitsUI)"); `NULL` shows nothing.
#' @return `<span class="kit-app-link">`.
#' @examples
#' kit_app_link("開啟 kitsUI", "https://example.org/kitsui/", kind = "secondary",
#'              note = "（開啟網路上的雲端版 kitsUI）")
#' @export
kit_app_link <- function(label, href, kind = "link", class = NULL, note = NULL) {
  is_link <- identical(kind, "link")
  link_class <- if (is_link) class else paste(c("btn kit-ext-btn", KIT_BTN[[kind]], class), collapse = " ")
  shiny::tags$span(
    class = "kit-app-link",
    shiny::tags$a(
      href = href, target = "_blank", rel = "noopener noreferrer", class = link_class,
      if (!is_link) shiny::icon("arrow-up-right-from-square"),
      label
    ),
    if (!is.null(note)) " ",
    if (!is.null(note)) shiny::tags$small(class = "kit-hint", note)
  )
}
