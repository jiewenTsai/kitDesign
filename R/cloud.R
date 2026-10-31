# 雲端版（Posit Connect Cloud）：判斷、頁首下面的提醒橫幅、頁尾的使用須知
#
# 判斷與畫法在這裡；文字（伺服器在哪裡、使用須知的每一段）是各 app 自己的。

#' 是不是雲端版
#'
#' 先看環境變數 `KIT_DEPLOY`（`"cloud"` 或 `"local"`，在 Connect Cloud 設定）；
#' 沒有設定時，Posit Connect 預設的 `R_CONFIG_ACTIVE = "rsconnect"` 就算雲端版。
#'
#' @return `TRUE` 或 `FALSE`。
#' @seealso [kit_cloud_banner()]、[kit_cloud_footer()]
#' @examples
#' kit_is_cloud()
#' @export
kit_is_cloud <- function() {
  deploy <- tolower(Sys.getenv("KIT_DEPLOY"))
  if (nzchar(deploy)) return(identical(deploy, "cloud"))
  identical(Sys.getenv("R_CONFIG_ACTIVE"), "rsconnect")
}

#' 雲端版的提醒橫幅（頁首下面一行）
#'
#' 黃色的一行，提醒使用者資料會傳到雲端。文字由 app 自己寫（各 app 的伺服器位置、
#' 使用須知不同）。
#'
#' @param ... 橫幅的內容。
#' @return `<div class="alert alert-warning kit-cloud-banner" role="alert">`。
#' @examples
#' kit_cloud_banner("此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。")
#' @export
kit_cloud_banner <- function(...) {
  shiny::tags$div(class = "alert alert-warning kit-cloud-banner", role = "alert", ...)
}

#' 雲端版使用須知（頁面最下面，灰色小字）
#'
#' 一個標題、幾段（粗體的段名接句號，後面是內文）、最後一行參考連結（開新分頁）。
#' 段名接內文、內文串成一段，HTML 不會在中間插入空白。頁首的橫幅可以用
#' `<a href="#kit-cloud-terms">` 連到這裡。
#'
#' @param sections 每一段：具名 list 或字串向量，名字是段名（「一、資料傳輸與儲存」），
#'   值是內文（字串向量，直接接起來）。
#' @param links 參考連結：具名字串向量，名字是連結的字、值是網址；`NULL` 不放這一行。
#' @param title 最上面的標題。
#' @param id 頁尾的 id（橫幅的連結用）。
#' @return `<footer id="kit-cloud-terms" class="kit-cloud-footer">`。
#' @seealso [kit_cloud_banner()]、[kit_is_cloud()]
#' @examples
#' kit_cloud_footer(
#'   sections = list(
#'     "一、資料傳輸與儲存" = c("本雲端版部署於 Posit Connect Cloud。",
#'                              "本工具不另行保存您的資料。"),
#'     "二、免責聲明" = "本工具以現況提供。"
#'   ),
#'   links = c("Posit Trust Center" = "https://trust.posit.co")
#' )
#' @export
# 原文：雲端版使用須知
kit_cloud_footer <- function(sections, links = NULL, title = "\u96f2\u7aef\u7248\u4f7f\u7528\u9808\u77e5",
                             id = "kit-cloud-terms") {
  stopifnot(length(names(sections)) == length(sections), all(nzchar(names(sections))))
  section <- function(name, text) {
    shiny::tags$p(
      # 原文：。
      shiny::tags$strong(paste0(name, "\u3002"), .noWS = "after"),
      paste(text, collapse = "")
    )
  }
  link_line <- if (length(links) > 0) {
    anchors <- lapply(seq_along(links), function(i) {
      shiny::tags$a(href = links[[i]], target = "_blank", rel = "noopener noreferrer", names(links)[i])
    })
    # 連結之間放「 · 」
    parts <- unlist(lapply(seq_along(anchors), function(i) {
      # 原文： · 
      if (i == 1) anchors[i] else list(" \u00b7 ", anchors[[i]])
    }), recursive = FALSE)
    # 原文：參考連結：
    do.call(shiny::tags$p, c(list("\u53c3\u8003\u9023\u7d50\uff1a"), parts))
  }
  shiny::tags$footer(
    id = id,
    class = "kit-cloud-footer",
    shiny::tags$div(class = "kit-cloud-footer-title", title),
    unname(Map(section, names(sections), sections)),
    link_line
  )
}
