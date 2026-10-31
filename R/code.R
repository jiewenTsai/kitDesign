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

#' Code for one version (code panel)
#'
#' An S3 value object (class `kit_code`): code text plus a version name. It has an
#' [htmltools::as.tags()] method: put it straight into a page and it renders a line with "version
#' name (bold) + Copy" and the code box below, with the code first wrapped by [kit_code_wrap()] to
#' at most 70 columns per line (Chinese characters count as 2).
#' If a line is still too long after wrapping (e.g. a long string that cannot be broken), it gives
#' a warning (it does not stop), and the box scrolls sideways.
#'
#' @param code The code (a character vector; one element per line, or containing newlines).
#' @param label The version name, e.g. "tidyverse 版" ("tidyverse version"), "base R 版" ("base R
#'   version"), "kits 版" ("kits version").
#' @param width Maximum columns per line; `NULL` means no wrapping and no check.
#' @return A `kit_code` object.
#' @seealso [kit_code_blocks()], [kit_code_panel_ui()]
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

#' The code after wrapping; gives a warning when lines are still too long
#' Within one R session, the same code warns only once; `options(kitDesign.warn_long_code = FALSE)`
#' turns the warning off.
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
#' @param x A `kit_code` object.
#' @param ... Not used.
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

#' Turn code into a list of kit_code objects
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

#' Content of "How to do it in R": a note plus code in one or more versions (with "Copy")
#'
#' Each version is a [kit_code()]: a line with "version name (bold) + Copy" and the code box below
#' it; two versions are stacked vertically. Code lines are at most 70 columns ([kit_code_wrap()]);
#' ligatures are always turned off.
#'
#' @param snips The code: a string, a [kit_code()] object, or a named list / character vector of
#'   them (names are version names). kitJoin's `list(tidy = , base = )` is labeled "tidyverse 版"
#'   ("tidyverse version") and "base R 版" ("base R version"); `NULL` versions are skipped (e.g.
#'   with `base = NULL` there is only the tidyverse version). Without names the version name is
#'   "R".
#' @param note A one-line note at the top; `NULL` shows nothing.
#' @param width Maximum columns per line; `NULL` means no wrapping and no check.
#' @return [htmltools::tagList()].
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

#' Placeholder for "How to do it in R" (code panel)
#'
#' A [kit_detail()] inside the details row ([kit_details_row()]), collapsed by default; the server
#' fills `output_id` with [kit_render_code_panel()]. With modules, use [kit_code_panel_ui()].
#'
#' @param output_id The `uiOutput()` id that holds the content (wrap in `ns()` inside a module).
#' @param title The collapsible title.
#' @param open Whether it starts open (collapsed by default).
#' @return `<details class="kit-detail">`.
#' @examples
#' kit_details_row(kit_detail("預覽", "…"), kit_code_panel("code"))
#' @export
# 原文：用 R 怎麼做
kit_code_panel <- function(output_id, title = "\u7528 R \u600e\u9ebc\u505a", open = FALSE) {
  kit_detail(title, shiny::uiOutput(output_id), open = open)
}

#' Server side: render code into [kit_code_panel()]
#'
#' `output[["code"]] <- kit_render_code_panel(function() code_text())`.
#' Nothing is computed while the panel is collapsed (Shiny does not render hidden outputs; it
#' computes only when "用 R 怎麼做" ("How to do it in R") is opened). When `code()` stops
#' (`req()`), fails, or is empty, only the `empty` line is shown.
#'
#' @param code A function or reactive that returns the code: the `snips` of [kit_code_blocks()].
#' @param note,width See [kit_code_blocks()].
#' @param empty The one line shown while there is no code yet.
#' @return [shiny::renderUI()].
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
