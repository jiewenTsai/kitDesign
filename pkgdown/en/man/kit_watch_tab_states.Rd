% English translation of man/kit_watch_tab_states.Rd (roxygen2 output of R/tabs.R). Update by hand when the Chinese changes.
\name{kit_watch_tab_states}
\alias{kit_watch_tab_states}
\title{Send tab states to the browser whenever they change}
\usage{
kit_watch_tab_states(session, states)
}
\arguments{
\item{session}{The Shiny session.}

\item{states}{A reactive: the result of \code{\link[=kit_tab_states]{kit_tab_states()}}.}
}
\value{
The \code{shiny::observe()} observer (invisibly).
}
\description{
\code{kit_watch_tab_states(session, shiny::reactive(kit_tab_states(...)))}.
}
\examples{
if (interactive()) {
  server <- function(input, output, session) {
    kit_watch_tab_states(session, shiny::reactive(kit_tab_states(list(upload = "success"))))
  }
}
}
