# 驗證報告：每個 KIT 套件的 inst/validation/validation.md；準則在 kitDesign 的 criteria.md

#' Validation report of a KIT package
#'
#' Every KIT package keeps a validation report in `inst/validation/validation.md`, written to the
#' KIT validation standard (`kit_validation("kitDesign", "criteria")`). `kit_validation()` finds
#' the installed report and opens it; `kit_validation_url()` gives its address on GitHub (what the
#' apps link to, see [kit_page()]).
#'
#' @param package Package name, e.g. `"kits"`, `"kitsUI"`.
#' @param report `"validation"` (the package's report) or `"criteria"` (the standard; only in
#'   kitDesign).
#' @param open Open the file (in the browser or the default program for `.md`).
#' @return The path of the installed file, invisibly when it is opened; `NA` when the installed
#'   package has no report.
#' @examples
#' kit_validation("kitDesign", "criteria", open = FALSE)
#' kit_validation_url("kits")
#' @export
kit_validation <- function(package, report = c("validation", "criteria"), open = interactive()) {
  report <- match.arg(report)
  path <- system.file("validation", paste0(report, ".md"), package = package)
  if (!nzchar(path)) return(NA_character_)
  if (!isTRUE(open)) return(path)
  utils::browseURL(path)
  invisible(path)
}

#' @rdname kit_validation
#' @param branch Git branch (or tag) the link points to.
#' @return `kit_validation_url()`: the GitHub address of the report. The repository comes from the
#'   first GitHub address in the package's `URL` field; when there is none,
#'   `https://github.com/jiewenTsai/<package>`.
#' @export
kit_validation_url <- function(package, report = c("validation", "criteria"), branch = "main") {
  report <- match.arg(report)
  urls <- tryCatch(utils::packageDescription(package)$URL, error = function(e) NULL)
  urls <- trimws(strsplit(if (is.null(urls) || is.na(urls)) "" else urls, ",")[[1]])
  repo <- grep("^https://github\\.com/[^/]+/[^/]+/?$", urls, value = TRUE)
  repo <- if (length(repo) > 0) sub("/$", "", repo[1]) else paste0("https://github.com/jiewenTsai/", package)
  paste0(repo, "/blob/", branch, "/inst/validation/", report, ".md")
}

#' Add the validation report template to a package
#'
#' Copies `validation.md` (the template of the KIT validation standard) into
#' `<path>/inst/validation/`, with the package name, version and today's date filled in. An
#' existing report is not overwritten.
#'
#' @param path The package folder (it has a `DESCRIPTION`).
#' @return The path of the report, invisibly.
#' @examples
#' pkg <- file.path(tempdir(), "mypkg")
#' dir.create(pkg)
#' writeLines(c("Package: mypkg", "Version: 0.1.0"), file.path(pkg, "DESCRIPTION"))
#' use_kit_validation(pkg)
#' @export
use_kit_validation <- function(path = ".") {
  desc <- read.dcf(file.path(path, "DESCRIPTION"), fields = c("Package", "Version"))
  out <- file.path(path, "inst", "validation", "validation.md")
  if (file.exists(out)) {
    message("Already there: ", out)
    return(invisible(out))
  }
  dir.create(dirname(out), recursive = TRUE, showWarnings = FALSE)
  text <- readLines(system.file("templates", "validation", "validation.md", package = "kitDesign"),
                    encoding = "UTF-8")
  text <- gsub("{{package}}", desc[1, "Package"], text, fixed = TRUE)
  text <- gsub("{{version}}", desc[1, "Version"], text, fixed = TRUE)
  text <- gsub("{{date}}", format(Sys.Date()), text, fixed = TRUE)
  writeLines(text, out, useBytes = TRUE)
  message("Wrote ", out)
  invisible(out)
}

#' 版本行後面的「驗證報告」連結（kit_app_meta()）
#' @noRd
kit_validation_link <- function(package) {
  # 原文：驗證報告
  shiny::tags$a(href = kit_validation_url(package), target = "_blank", rel = "noopener",
                class = "kit-validation-link", "\u9a57\u8b49\u5831\u544a")
}
