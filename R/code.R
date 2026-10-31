# 用 R 怎麼做（CodePanel）
#
# 把目前的設定寫成可以照著跑的 R 程式碼，永遠收在細節列裡（最後一個）。
# 打開後由上而下：一行說明、版本名稱（粗體）與「複製」同一行、程式碼框。
# 只有程式碼本身有框；每行最多 70 欄（kit_code_wrap()），框最寬到版面寬度。
# 一般用模組 kit_code_panel_ui() / kit_code_panel_server()（R/modules.R）。

# 程式碼的版本名稱：list(tidy = , base = ) 的名字換成給人看的
# 原文：tidyverse 版 | base R 版
KIT_CODE_LABELS <- c(tidy = "tidyverse \u7248", base = "base R \u7248")

# 說明的預設
# 原文：以下程式碼依你目前的設定產生，是簡化的示範。
KIT_CODE_NOTE <- "\u4ee5\u4e0b\u7a0b\u5f0f\u78bc\u4f9d\u4f60\u76ee\u524d\u7684\u8a2d\u5b9a\u7522\u751f\uff0c\u662f\u7c21\u5316\u7684\u793a\u7bc4\u3002"

# 還沒有程式碼時的一行字（kitsUI 的 KIT_CODE_EMPTY）
# 原文：先選資料，這裡才會有程式碼。
KIT_CODE_EMPTY <- "\u5148\u9078\u8cc7\u6599\uff0c\u9019\u88e1\u624d\u6703\u6709\u7a0b\u5f0f\u78bc\u3002"

#' 一個版本的程式碼（CodePanel）
#'
#' 一個 S3 值物件（class `kit_code`）：程式碼文字＋版本名稱。有 [htmltools::as.tags()] 方法：
#' 直接放進頁面就畫成「版本名稱（粗體）＋複製」一行和下面的程式碼框，
#' 程式碼先用 [kit_code_wrap()] 換行成每行最多 70 欄（中文字算 2 欄）。
#' 換行後還是有太長的行（例如斷不開的長字串）時發出 warning（不會停下來），在框裡左右捲。
#'
#' @param code 程式碼（字串向量；一個元素一行，或含換行）。
#' @param label 版本名稱，例如「tidyverse 版」「base R 版」「kits 版」。
#' @param width 一行最多幾欄；`NULL` 不換行、不檢查。
#' @return `kit_code` 物件。
#' @seealso [kit_code_blocks()]、[kit_code_panel_ui()]
#' @examples
#' x <- kit_code("joined <- dplyr::left_join(t1, t2, by = \"id\")", "tidyverse 版")
#' x
#' htmltools::as.tags(x)
#' @export
kit_code <- function(code, label = "R", width = KIT_CODE_WIDTH) {
  if (!is.character(code) || anyNA(code)) stop("`code` must be a character vector without NA.", call. = FALSE)
  if (!(is.character(label) && length(label) == 1 && !is.na(label) && nzchar(label))) {
    stop("`label` must be one non-empty string.", call. = FALSE)
  }
  if (!is.null(width) && !(is.numeric(width) && length(width) == 1 && width >= 20)) {
    stop("`width` must be one number (at least 20) or NULL.", call. = FALSE)
  }
  structure(list(code = paste(code, collapse = "\n"), label = label, width = width), class = "kit_code")
}

# 已經提醒過的程式碼（同一段只提醒一次：畫面每次更新都會重畫）
kit_code_warned <- new.env(parent = emptyenv())

#' 換行以後的程式碼；還有太長的行時發出 warning
#' 同一個 R session 裡，同一段程式碼只提醒一次；`options(kitDesign.warn_long_code = FALSE)` 不提醒。
#' @noRd
kit_code_text <- function(x) {
  code <- sub("\\s+$", "", x$code)
  if (is.null(x$width)) return(code)
  code <- kit_code_wrap(code, x$width)
  lines <- strsplit(code, "\n", fixed = TRUE)[[1]]
  long <- which(kit_code_cols(lines) > x$width)
  key <- paste(x$label, x$width, code, sep = "\r")
  if (length(long) > 0 && isTRUE(getOption("kitDesign.warn_long_code", TRUE)) &&
      is.null(kit_code_warned[[key]])) {
    assign(key, TRUE, envir = kit_code_warned)
    warning(sprintf(
      "%s: %d line(s) still longer than %d columns after wrapping (CJK characters count as 2): line %s",
      x$label, length(long), x$width, paste(long, collapse = ", ")
    ), call. = FALSE)
  }
  code
}

#' @rdname kit_code
#' @param x `kit_code` 物件。
#' @param ... 不用。
#' @exportS3Method htmltools::as.tags
as.tags.kit_code <- function(x, ...) {
  shiny::tagList(
    shiny::tags$div(
      class = "kit-code-head",
      shiny::tags$strong(x$label),
      shiny::tags$button(type = "button", class = paste("btn", KIT_BTN[["secondary"]], "kit-copy"),
                         # 原文：複製
                         "\u8907\u88fd")
    ),
    # 直接組 HTML：避免 tags$pre() 排版時在程式碼前插入縮排空白
    shiny::HTML(paste0("<pre><code>", htmltools::htmlEscape(kit_code_text(x)), "</code></pre>"))
  )
}

#' @rdname kit_code
#' @export
format.kit_code <- function(x, ...) {
  c(paste0("## ", x$label), strsplit(suppressWarnings(kit_code_text(x)), "\n", fixed = TRUE)[[1]])
}

#' @rdname kit_code
#' @export
print.kit_code <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
  invisible(x)
}

#' 把程式碼整理成 kit_code 的 list
#' @noRd
kit_as_codes <- function(snips, width) {
  if (inherits(snips, "kit_code")) return(list(snips))
  if (is.character(snips) && is.null(names(snips))) snips <- list(R = paste(snips, collapse = "\n"))
  snips <- as.list(snips)
  snips <- snips[!vapply(snips, is.null, logical(1))]
  labels <- names(snips) %||% rep("", length(snips))
  out <- lapply(seq_along(snips), function(i) {
    s <- snips[[i]]
    if (inherits(s, "kit_code")) return(s)
    label <- labels[[i]]
    if (label %in% names(KIT_CODE_LABELS)) label <- KIT_CODE_LABELS[[label]]
    if (!nzchar(label)) label <- "R"
    kit_code(s, label, width = width)
  })
  out
}

#' 「用 R 怎麼做」的內容：說明＋一個或幾個版本的程式碼（附「複製」）
#'
#' 每個版本是一個 [kit_code()]：一行「版本名稱（粗體）＋複製」與下面的程式碼框；
#' 兩個版本時上下排。程式碼每行最多 70 欄（[kit_code_wrap()]）；一律關掉連字。
#'
#' @param snips 程式碼：一個字串、[kit_code()] 物件，或它們的具名 list／字串向量
#'   （名字是版本名稱）。kitJoin 的 `list(tidy = , base = )` 會寫成「tidyverse 版」「base R 版」；
#'   `NULL` 的版本略過（例如 `base = NULL` 時只有 tidyverse 版）。沒有名字時版本名稱是「R」。
#' @param note 最上面的一行說明；`NULL` 不顯示。
#' @param width 一行最多幾欄；`NULL` 不換行、不檢查。
#' @return [htmltools::tagList()]。
#' @examples
#' kit_code_blocks(list(
#'   tidy = "joined <- dplyr::left_join(t1, t2, by = \"id\")",
#'   base = "joined <- merge(t1, t2, by = \"id\", all.x = TRUE)"
#' ))
#' kit_code_blocks(c("kits 版" = "fit <- kits::kits_calibrate(resp)"))
#' @export
kit_code_blocks <- function(snips, note = KIT_CODE_NOTE, width = KIT_CODE_WIDTH) {
  codes <- kit_as_codes(snips, width)
  shiny::tagList(
    if (!is.null(note)) shiny::tags$p(class = "kit-hint", note),
    lapply(codes, htmltools::as.tags)
  )
}

#' 「用 R 怎麼做」的位置（CodePanel）
#'
#' 細節列（[kit_details_row()]）裡的一個 [kit_detail()]，預設收起；內容由 server 用
#' [kit_render_code_panel()] 填進 `output_id`。用模組時是 [kit_code_panel_ui()]。
#'
#' @param output_id 放內容的 `uiOutput()` id（模組裡要加 `ns()`）。
#' @param title 收合標題。
#' @param open 一開始要不要打開（預設收起）。
#' @return `<details class="kit-detail">`。
#' @examples
#' kit_details_row(kit_detail("預覽", "…"), kit_code_panel("code"))
#' @export
# 原文：用 R 怎麼做
kit_code_panel <- function(output_id, title = "\u7528 R \u600e\u9ebc\u505a", open = FALSE) {
  kit_detail(title, shiny::uiOutput(output_id), open = open)
}

#' server 端：把程式碼畫進 [kit_code_panel()]
#'
#' `output[["code"]] <- kit_render_code_panel(function() code_text())`。
#' 收起來時不算（Shiny 不畫看不見的 output；打開「用 R 怎麼做」時才算）。`code()` 停下來
#' （`req()`）、出錯或是空的時，只有一行 `empty`。
#'
#' @param code 傳回程式碼的函式或 reactive：[kit_code_blocks()] 的 `snips`。
#' @param note,width 見 [kit_code_blocks()]。
#' @param empty 還沒有程式碼時的一行字。
#' @return [shiny::renderUI()]。
#' @examples
#' if (interactive()) {
#'   server <- function(input, output, session) {
#'     output$code <- kit_render_code_panel(function() "x <- 1")
#'   }
#' }
#' @export
kit_render_code_panel <- function(code, note = KIT_CODE_NOTE, width = KIT_CODE_WIDTH,
                                  empty = KIT_CODE_EMPTY) {
  shiny::renderUI({
    snips <- tryCatch(code(), error = function(e) NULL)
    text <- if (inherits(snips, "kit_code")) snips$code else
      unlist(lapply(snips, function(s) if (inherits(s, "kit_code")) s$code else s))
    if (length(text) == 0 || !any(nzchar(text))) {
      return(shiny::tags$p(class = "kit-hint mb-0", empty))
    }
    kit_code_blocks(snips, note = note, width = width)
  })
}
