# 雲端版（Posit Connect Cloud）：判斷、頁首下面的提醒橫幅、頁尾的使用須知
#
# 判斷與畫法在這裡；文字（伺服器在哪裡、使用須知的每一段）是各 app 自己的。

#' Is this the cloud version?
#'
#' Checks the environment variable `KIT_DEPLOY` first (`"cloud"` or `"local"`, set in Connect Cloud);
#' if it is not set, Posit Connect's default `R_CONFIG_ACTIVE = "rsconnect"` counts as the cloud
#' version.
#'
#' @return `TRUE` or `FALSE`.
#' @seealso [kit_cloud_banner()], [kit_cloud_footer()]
#' @examples
#' kit_is_cloud()
#' @export
kit_is_cloud <- function() {
  deploy <- tolower(Sys.getenv("KIT_DEPLOY"))
  if (nzchar(deploy)) return(identical(deploy, "cloud"))
  identical(Sys.getenv("R_CONFIG_ACTIVE"), "rsconnect")
}

#' Cloud version reminder banner (one line below the header)
#'
#' A yellow line reminding users that their data go to the cloud. The app writes the text itself
#' (each app's server location and usage notes differ).
#'
#' @param ... The banner content.
#' @return `<div class="alert alert-warning kit-cloud-banner" role="alert">`.
#' @examples
#' kit_cloud_banner("此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。")
#' # "This is the cloud version: uploaded data are sent to a cloud server. For data with personal information, use the local version."
#' @export
kit_cloud_banner <- function(...) {
  shiny::tags$div(class = "alert alert-warning kit-cloud-banner", role = "alert", ...)
}

#' Cloud version usage notes (bottom of the page, small gray text)
#'
#' A title, a few sections (bold section title followed by a period, then the body), and a final line
#' of reference links (opening in new tabs). Section titles run into the body and body pieces are
#' joined into one paragraph, with no spaces inserted by HTML. The header banner can link here with
#' `<a href="#kit-cloud-terms">`.
#'
#' @param sections The sections: a named list or character vector; names are section titles
#'   ("一、資料傳輸與儲存", "1. Data transfer and storage"), values are the body text (a character
#'   vector, joined directly).
#' @param links Reference links: a named character vector, names are the link text and values are
#'   URLs; `NULL` omits this line.
#' @param title The title at the top.
#' @param id The footer's id (used by the banner's link).
#' @return `<footer id="kit-cloud-terms" class="kit-cloud-footer">`.
#' @seealso [kit_cloud_banner()], [kit_is_cloud()]
#' @examples
#' # Sections: "1. Data transfer and storage", "2. Disclaimer"
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
