% English translation of man/kit_open_details.Rd (roxygen2 output of R/server.R). Update by hand when the Chinese changes.
\name{kit_open_details}
\alias{kit_open_details}
\title{Open a collapsible section (for example, open the advanced settings after applying a preset)}
\usage{
kit_open_details(id, session = shiny::getDefaultReactiveDomain())
}
\arguments{
\item{id}{The id of the \verb{<details>} (the id inside the module; the namespace is added automatically), for example
the \code{id} of \code{\link[=kit_advanced]{kit_advanced()}}.}

\item{session}{Defaults to the current session.}
}
\value{
The full id, invisibly; \code{NULL} when there is no session.
}
\description{
Open a collapsible section (for example, open the advanced settings after applying a preset).
}
\examples{
if (interactive()) kit_open_details("advanced")
}
