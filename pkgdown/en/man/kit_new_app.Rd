% English translation of man/kit_new_app.Rd (roxygen2 output of R/new_app.R). Update by hand when the Chinese changes.
\name{kit_new_app}
\alias{kit_new_app}
\title{Start a new KIT Shiny app}
\usage{
kit_new_app(
  path,
  title,
  subtitle = "臺灣幼兒發展調查資料庫",
  package = basename(path)
)
}
\arguments{
\item{path}{The new folder (the last part is the package name, e.g. \code{"~/kitScore"}).}

\item{title}{The tool name, e.g. "KIT 計分工具" ("KIT scoring tool").}

\item{subtitle}{The subtitle, e.g. "臺灣幼兒發展調查資料庫" (the KIT database).}

\item{package}{The package name (defaults to the folder name): starts with a letter and contains only letters, digits, and periods.}
}
\value{
\code{path} (full path), invisibly.
}
\description{
Creates a ready-to-run app package skeleton, with one example tab written to the KIT design language's page skeleton:
}
\details{
\itemize{
\item \code{DESCRIPTION}: \verb{Imports: kitDesign (>= current version)}, \code{Remotes: jiewenTsai/kitDesign@v<current version>}.
\item \code{app.R}: the entry point for Posit Connect Cloud (primary file).
\item \code{R/app.R}: \code{\link[=kit_page]{kit_page()}} plus the step tabs module (\code{\link[=kit_step_tabs_ui]{kit_step_tabs_ui()}}); \code{run_app()}.
\item \code{R/page_calc.R}: an example tab using a primary button plus the ready line (\code{\link[=kit_run_gate_ui]{kit_run_gate_ui()}}), a status box, a result table,
"How to do it in R" (\code{\link[=kit_code_panel_ui]{kit_code_panel_ui()}}), and next step.
\item \verb{tests/testthat/}: one \code{shiny::testServer()} test.
\item \code{.gitignore} (including \verb{tests/testthat/_problems/} and \code{testthat-problems.rds}), \code{.Rbuildignore},
\code{README.md}, \code{LICENSE}.
}

If the folder already exists and is not empty, it does nothing and stops (it never overwrites any file).
}
\examples{
dir <- file.path(tempdir(), "kitDemo")
kit_new_app(dir, "KIT 示範工具", "臺灣幼兒發展調查資料庫")  # "KIT demo tool", the KIT database
list.files(dir, recursive = TRUE)
unlink(dir, recursive = TRUE)
}
