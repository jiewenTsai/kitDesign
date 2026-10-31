# 細節列、進階設定、設定摘要（Details）

#' 進階設定：預設收起
#'
#' 設定區裡不常改的選項（文字欄比對、ID 型別轉換、反向題規則、分隔符號…）。
#' 一行小字標題；打開後左邊一條淡線，和其他設定分開（不加框）。
#'
#' @param ... 裡面的設定。
#' @param title 收合標題（可以是 tag，例如後面接現在的設定）。
#' @param open 一開始要不要打開。
#' @param id `<details>` 的 id（給 [kit_open_details()] 打開用）。
#' @return `<details class="kit-advanced">`。
#' @examples
#' kit_advanced(shiny::checkboxInput("trim", "比對前去掉前後空白", TRUE))
#' @export
# 原文：進階設定
kit_advanced <- function(..., title = "\u9032\u968e\u8a2d\u5b9a", open = FALSE, id = NULL) {
  shiny::tags$details(
    id = id, class = "kit-advanced", open = if (open) NA,
    shiny::tags$summary(title),
    shiny::tags$div(class = "kit-advanced-body", ...)
  )
}

#' 一排細節（Details）
#'
#' 結果下面一排收起來的小字標題（▸ 預覽　▸ 這一回合的紀錄　▸ 用 R 怎麼做）；
#' 打開的那一個佔一整行，內容不加框。「用 R 怎麼做」永遠放在最後一個。
#'
#' @param ... [kit_detail()]（或 [kit_code_panel()]）。
#' @return `<div class="kit-details">`。
#' @examples
#' kit_details_row(
#'   kit_detail("預覽", "前 10 列"),
#'   kit_detail("這一回合的紀錄", "沒有提醒。")
#' )
#' @export
kit_details_row <- function(...) {
  shiny::tags$div(class = "kit-details", ...)
}

#' 一個細節：預設收起，標題一行小字
#'
#' 收起來的 output 要打開才算出來：`kit.js` 會在打開時通知 Shiny 重新檢查。
#'
#' @param title 標題（名詞：「題目參數」「這一回合的紀錄」）。
#' @param ... 內容。
#' @param open 一開始要不要打開。
#' @return `<details class="kit-detail">`。
#' @examples
#' kit_detail("預覽", shiny::tags$p("前 10 列"))
#' @export
kit_detail <- function(title, ..., open = FALSE) {
  shiny::tags$details(
    class = "kit-detail", open = if (open) NA,
    shiny::tags$summary(title),
    shiny::tags$div(class = "kit-detail-body", ...)
  )
}

#' 設定摘要：主要按鈕或結果上面一行小字
#'
#' 例如「本次：5 個檔案 · ID：各檔各自 · 全勤樣本」。
#'
#' @param parts 各段文字（空字串、`NA` 與 `NULL` 略過），用「 · 」接起來；
#'   也可以是已經寫好的一整句（kitsUI 的 `ui_settings_line(text)`，這時用 `prefix = NULL`）。
#' @param prefix 前面的字，預設「本次：」；`NULL` 不加。
#' @return `<p class="kit-settings-line">`；沒有任何一段時是 `NULL`。
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
