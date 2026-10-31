% English translation of man/kit_btn_class.Rd (roxygen2 output of R/buttons.R). Update by hand when the Chinese changes.
\name{kit_btn_class}
\alias{kit_btn_class}
\title{Class for a button kind}
\usage{
kit_btn_class(kind = c("secondary", "primary", "danger"))
}
\arguments{
\item{kind}{\code{"primary"} (primary button), \code{"secondary"} (secondary button), or \code{"danger"} (danger button).}
}
\value{
A class string, e.g. \code{"btn-sm btn-outline-secondary"}.
}
\description{
When you build a button yourself (e.g. \code{downloadButton()}, \verb{<a class="btn">}), use this class
so it looks the same as \code{\link[=kit_button]{kit_button()}}.
}
\examples{
kit_btn_class("secondary")
}
