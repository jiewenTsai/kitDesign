% English translation of man/kit_send_tab_states.Rd (roxygen2 output of R/tabs.R). Update by hand when the Chinese changes.
\name{kit_send_tab_states}
\alias{kit_send_tab_states}
\title{Send tab states to the browser}
\usage{
kit_send_tab_states(states, session = shiny::getDefaultReactiveDomain())
}
\arguments{
\item{states}{The result of \code{\link[=kit_tab_states]{kit_tab_states()}}.}

\item{session}{Defaults to the current session.}
}
\value{
\code{states}, invisibly.
}
\description{
Works with both kinds of tab bar: grouped tab bars (\code{\link[=kit_navgroups]{kit_navgroups()}}, \code{data-tabset} is \code{tabset}) and
flow tabs (\code{\link[=kit_flow_tabs]{kit_flow_tabs()}}, \code{id} is \code{tabset}).
}
\examples{
if (interactive()) kit_send_tab_states(kit_tab_states(list(upload = "success")))
}
