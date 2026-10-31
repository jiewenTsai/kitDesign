# 開一個新的 KIT app（套件骨架）

#' Start a new KIT Shiny app
#'
#' Creates a ready-to-run app package skeleton, with one example tab written to the KIT design
#' language's page skeleton:
#'
#' - `DESCRIPTION`: `Imports: kitDesign (>= current version)`,
#'   `Remotes: jiewenTsai/kitDesign@v<current version>`.
#' - `app.R`: the entry point for Posit Connect Cloud (primary file).
#' - `R/app.R`: [kit_page()] plus the step tabs module ([kit_step_tabs_ui()]); `run_app()`.
#' - `R/page_calc.R`: an example tab using a primary button plus the ready line
#'   ([kit_run_gate_ui()]), a status box, a result table, "How to do it in R"
#'   ([kit_code_panel_ui()]), and next step.
#' - `tests/testthat/`: one `shiny::testServer()` test.
#' - `.gitignore` (including `tests/testthat/_problems/` and `testthat-problems.rds`),
#'   `.Rbuildignore`, `README.md`, `LICENSE`.
#'
#' If the folder already exists and is not empty, it does nothing and stops (it never overwrites
#' any file).
#'
#' @param path The new folder (the last part is the package name, e.g. `"~/kitScore"`).
#' @param title The tool name, e.g. "KIT 計分工具" ("KIT scoring tool").
#' @param subtitle The subtitle, e.g. "臺灣幼兒發展調查資料庫" (the KIT database).
#' @param package The package name (defaults to the folder name): starts with a letter and contains
#'   only letters, digits, and periods.
#' @return `path` (full path), invisibly.
#' @examples
#' dir <- file.path(tempdir(), "kitDemo")
#' kit_new_app(dir, "KIT 示範工具", "臺灣幼兒發展調查資料庫")  # "KIT demo tool", the KIT database
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
