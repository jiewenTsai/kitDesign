% English translation of man/kit_app_meta.Rd (roxygen2 output of R/setup.R). Update by hand when the Chinese changes.
\name{kit_app_meta}
\alias{kit_app_meta}
\title{The version line in the header, e.g. "kitJoin v0.6.0 · 2026-10-31"}
\usage{
kit_app_meta(
  version = NULL,
  date = NULL,
  extra = NULL,
  show_kitdesign = FALSE,
  package = NULL
)
}
\arguments{
\item{version}{The version ("v" is added in front); \code{NULL} or \code{NA} shows nothing.}

\item{date}{The date; \code{NULL} or \code{NA} shows nothing.}

\item{extra}{Text to append (e.g. \code{paste("kits", utils::packageVersion("kits"))}).}

\item{show_kitdesign}{Whether to append "kitDesign 0.1.0" (\code{\link[=kit_versions]{kit_versions()}}).}

\item{package}{The app's package name, written before the version ("kitJoin v0.6.0"); \code{NULL} writes no name.}
}
\value{
\verb{<div class="kit-app-meta">}; \code{NULL} when all three are missing.
}
\description{
The version line always sits in the header; it is needed when reporting problems.
}
\examples{
kit_app_meta("0.5.0", "2026-10-31")
kit_app_meta("0.6.0", "2026-10-31", package = "kitJoin")
}
