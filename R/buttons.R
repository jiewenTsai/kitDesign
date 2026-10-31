# 按鈕、提示框、下一步、連到別的 app

# 按鈕的寫法（KIT 設計語言 Button）：主要按鈕一頁一個（加上最下面的「下一步」）；
# 次要按鈕（下載、全選、上移…）白底、小一號；危險按鈕（移除、這一回合不做）鮭紅底
KIT_BTN <- c(
  primary = "btn-primary",
  secondary = "btn-sm btn-outline-secondary",
  danger = "btn-sm btn-danger"
)

#' 按鈕種類的 class
#'
#' 自己畫按鈕（例如 `downloadButton()`、`<a class="btn">`）時，用這裡的 class，
#' 和 [kit_button()] 長得一樣。
#'
#' @param kind `"primary"`（主要按鈕）、`"secondary"`（小按鈕）或 `"danger"`（危險按鈕）。
#' @return class 字串，例如 `"btn-sm btn-outline-secondary"`。
#' @examples
#' kit_btn_class("secondary")
#' @export
kit_btn_class <- function(kind = c("secondary", "primary", "danger")) {
  kind <- match.arg(kind)
  unname(KIT_BTN[[kind]])
}

#' 按鈕（Button）
#'
#' 一個 [shiny::actionButton()]，class 照按鈕的種類：
#'
#' - `"primary"`：主要按鈕，萊姆底、大字、卡片陰影。一頁一個，加上最下面的「下一步」。
#' - `"secondary"`：小按鈕，白底、細框、沒有陰影。用在下載、全選、範例檔、上移下移、複製。
#' - `"danger"`：危險按鈕，鮭紅底。用在刪除、移除、這一回合不做。
#'
#' 一般按鈕（白底、黑框、小陰影，例如「對，下一步」）直接用 `shiny::actionButton()`。
#' 文字用動詞開頭，說清楚按下去會發生什麼；會離開這一頁的，文字後面加「→」。
#'
#' @param id 按鈕的 input id。
#' @param label 按鈕上的字。
#' @param kind `"primary"`、`"secondary"` 或 `"danger"`。
#' @param ... 其他傳給 [shiny::actionButton()] 的參數（例如 `disabled = TRUE`、`icon`）。
#' @param class 另外加的 class。
#' @return `<button class="btn ...">`。
#' @examples
#' kit_button("run", "執行串接", "primary")
#' kit_button("all", "全選")
#' kit_button("drop", "這一回合不做", "danger")
#' @export
kit_button <- function(id, label, kind = "secondary", ..., class = NULL) {
  shiny::actionButton(id, label, class = paste(c(KIT_BTN[[kind]], class), collapse = " "), ...)
}

#' 提示框（Callout）
#'
#' 按下去之前就該知道的提醒，不是結果，所以沒有陰影。一個區塊最多一個；
#' 能寫進狀態框的，就不要另外開提示框；有按鈕時，按鈕放在框外面。
#'
#' @param ... 框裡的內容。
#' @param warn `FALSE`：天藍的資訊；`TRUE`：黃色的注意。
#' @param class 另外加的 class。
#' @return `<div class="kit-callout">`（注意時再加 `kit-callout-warn`）。
#' @examples
#' kit_callout("外部連結不適用：這一回合只有一個世代，這不是錯誤。")
#' kit_callout("資料裡有疑似遺漏值代碼，建議先到「遺漏值處理」。", warn = TRUE)
#' @export
kit_callout <- function(..., warn = FALSE, class = NULL) {
  shiny::tags$div(
    class = paste(c("kit-callout", if (warn) "kit-callout-warn", class), collapse = " "),
    ...
  )
}

#' 下一步（NextStep）
#'
#' 頁面最下面、靠右：左邊一句小字（可以是幾個去處的清單），右邊一個按鈕
#' 「下一步：××× →」。結果出來以後（【完成】或【完成，但請注意】）才顯示；
#' 結果過期（【要重新執行】）時拿掉。
#'
#' @param text 左邊的小字；`NULL` 不顯示。
#' @param button_id 按鈕的 id；`NULL` 時不畫按鈕（除非給了 `button`）。
#' @param label 按鈕的字，例如「下一步：橫向資料串接」；後面自動加「 →」。
#' @param button 不用 actionButton 時直接給按鈕（例如連到別的 app 的連結）。
#' @param kind 按鈕的種類：預設是主要按鈕；這一頁另有主角時（例如下載）用 `"secondary"`。
#' @return `<div class="kit-next">`。
#' @examples
#' kit_next_step("串接好了，可以接著做 kits 作答檔。", "next", "下一步：kits 作答檔")
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

#' 連到別的網站或 app 的連結（開新分頁）
#'
#' 例如從 kitJoin 連到 kitsUI 的雲端版。連結開新分頁（`target="_blank"`），
#' 後面可以接一行小字說明會開到哪裡。要不要放連結（本機版、雲端版）由 app 自己決定。
#'
#' @param label 連結的字，例如「開啟 kitsUI」。
#' @param href 網址。
#' @param kind `"link"`（文字連結）或按鈕的種類（`"secondary"`、`"primary"`）。
#' @param class 連結另外加的 class（例如 `"kit-next-link"`）。
#' @param note 後面的一行小字，例如「（開啟網路上的雲端版 kitsUI）」；`NULL` 不顯示。
#' @return `<span class="kit-app-link">`。
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
