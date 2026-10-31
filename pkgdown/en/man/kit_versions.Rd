% English translation of man/kit_versions.Rd (roxygen2 output of R/setup.R). Update by hand when the Chinese changes.
\name{kit_versions}
\alias{kit_versions}
\title{Versions: kitDesign and the app's own}
\usage{
kit_versions(package = NULL)
}
\arguments{
\item{package}{The app's package name (for example \code{"kitJoin"}); with \code{NULL}, only kitDesign.
Versions are read the same way as \code{\link[=kit_app_description]{kit_app_description()}}.}
}
\value{
A named character vector, for example \code{c(kitDesign = "0.1.0", kitJoin = "0.5.0")}.
}
\description{
When reporting a problem, include both versions. The header's version line can include the kitDesign version:
\code{kit_page(..., show_kitdesign = TRUE)} → "v0.5.0 · 2026-10-31 · kitDesign 0.1.0".
}
\examples{
kit_versions()
}
