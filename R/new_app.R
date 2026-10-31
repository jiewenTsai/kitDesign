# 開一個新的 KIT app（套件骨架）

#' 開一個新的 KIT Shiny app
#'
#' 建立一個可以直接執行的 app 套件骨架，照 KIT 設計語言的頁面骨架寫好一個範例分頁：
#'
#' - `DESCRIPTION`：`Imports: kitDesign (>= 目前版本)`、`Remotes: jiewenTsai/kitDesign@v目前版本`。
#' - `app.R`：Posit Connect Cloud 的入口（primary file）。
#' - `R/app.R`：[kit_page()]＋步驟分頁模組（[kit_step_tabs_ui()]）；`run_app()`。
#' - `R/page_calc.R`：範例分頁，用了主要按鈕＋還差（[kit_run_gate_ui()]）、狀態框、結果表、
#'   用 R 怎麼做（[kit_code_panel_ui()]）、下一步。
#' - `tests/testthat/`：一個 `shiny::testServer()` 測試。
#' - `.gitignore`（含 `tests/testthat/_problems/`、`testthat-problems.rds`）、`.Rbuildignore`、
#'   `README.md`、`LICENSE`。
#'
#' 資料夾已經存在而且不是空的時候，什麼都不做、停下來（不會蓋掉任何檔案）。
#'
#' @param path 新的資料夾（最後一層是套件名稱，例如 `"~/kitScore"`）。
#' @param title 工具名稱，例如「KIT 計分工具」。
#' @param subtitle 副標，例如「臺灣幼兒發展調查資料庫」。
#' @param package 套件名稱（預設是資料夾名稱）：英文字母開頭，只有英文字母、數字和點。
#' @return 不可見的 `path`（完整路徑）。
#' @examples
#' dir <- file.path(tempdir(), "kitDemo")
#' kit_new_app(dir, "KIT 示範工具", "臺灣幼兒發展調查資料庫")
#' list.files(dir, recursive = TRUE)
#' unlink(dir, recursive = TRUE)
#' @export
# 原文：臺灣幼兒發展調查資料庫
kit_new_app <- function(path, title, subtitle = "\u81fa\u7063\u5e7c\u5152\u767c\u5c55\u8abf\u67e5\u8cc7\u6599\u5eab", package = basename(path)) {
  if (!(is.character(path) && length(path) == 1 && nzchar(path))) {
    stop("`path` must be one folder path.", call. = FALSE)
  }
  if (!grepl("^[A-Za-z][A-Za-z0-9.]*[A-Za-z0-9]$", package)) {
    stop("`package` must start with a letter and contain only letters, digits and dots: \"",
         package, "\".", call. = FALSE)
  }
  if (!(is.character(title) && length(title) == 1 && nzchar(title))) {
    stop("`title` must be one non-empty string.", call. = FALSE)
  }
  if (dir.exists(path) && length(list.files(path, all.files = TRUE, no.. = TRUE)) > 0) {
    stop("The folder already exists and is not empty: ", path, call. = FALSE)
  }
  src <- system.file("templates", "newapp", package = "kitDesign")
  if (!nzchar(src)) stop("Could not find the app template. Try re-installing kitDesign.", call. = FALSE)

  values <- c(
    package = package, title = title, subtitle = subtitle %||% "",
    version = kit_pkg_version(), date = format(Sys.Date()), year = format(Sys.Date(), "%Y")
  )
  files <- list.files(src, recursive = TRUE, all.files = TRUE)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  for (f in files) {
    out <- sub("\\.tmpl$", "", f)
    if (out %in% c("gitignore", "Rbuildignore")) out <- paste0(".", out)
    text <- readLines(file.path(src, f), encoding = "UTF-8", warn = FALSE)
    for (key in names(values)) text <- gsub(paste0("{{", key, "}}"), values[[key]], text, fixed = TRUE)
    target <- file.path(path, out)
    dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
    con <- file(target, open = "w", encoding = "UTF-8")
    writeLines(enc2utf8(text), con, useBytes = TRUE)
    close(con)
  }
  invisible(normalizePath(path))
}
