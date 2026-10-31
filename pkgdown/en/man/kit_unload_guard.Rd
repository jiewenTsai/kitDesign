% English translation of man/kit_unload_guard.Rd (roxygen2 output of R/server.R). Update by hand when the Chinese changes.
\name{kit_unload_guard}
\alias{kit_unload_guard}
\title{Reminder before leaving the page}
\usage{
kit_unload_guard(on = TRUE, session = shiny::getDefaultReactiveDomain())
}
\arguments{
\item{on}{\code{TRUE} turns it on, \code{FALSE} turns it off.}

\item{session}{Defaults to the current session.}
}
\value{
\code{on}, invisibly.
}
\description{
When there are results from this session (for example, after calibration), the browser asks once before the tab is closed or reloaded.
Turn it on and off in the server based on the result: \code{shiny::observe(kit_unload_guard(!is.null(result())))}.
}
\examples{
if (interactive()) kit_unload_guard(TRUE)
}
