% English translation of man/kit_tab_states.Rd (roxygen2 output of R/tabs.R). Update by hand when the Chinese changes.
\name{kit_tab_states}
\alias{kit_tab_states}
\title{State of each tab}
\usage{
kit_tab_states(
  status,
  locked = character(0),
  locked_tips = NULL,
  tabset = "tabs"
)
}
\arguments{
\item{status}{A named list or character vector: names are tab values, values are states.
Tabs not listed are left unchanged.}

\item{locked}{Tabs that cannot be used yet: a character vector of values, or a named logical.}

\item{locked_tips}{The hover text for tabs that cannot be used yet: one string (the same for all), or a character vector named by value.}

\item{tabset}{The tabset id (\code{tabsetPanel(id = )}).}
}
\value{
A list with one \code{list(tabset, value, state, tip)} per tab.
}
\description{
Works out how each tab looks from the state of its status box (the \code{state} of \code{\link[=kit_status]{kit_status()}}):
}
\details{
\itemize{
\item \code{"locked"} (gray): tabs listed in \code{locked}. The hover text is \code{locked_tips}.
\item \code{"done"} (with ✓): the state is \code{"success"} or \code{"warning"} (or directly \code{"done"}).
\item \code{"stale"} (✓ removed): the state is \code{"stale"}.
\item \code{"ready"}: anything else (\code{"idle"}, \code{"error"}, \code{"ready"}).
}

Pass the result to \code{\link[=kit_send_tab_states]{kit_send_tab_states()}} (or \code{\link[=kit_watch_tab_states]{kit_watch_tab_states()}}) to send it to the browser.
}
\examples{
kit_tab_states(
  list(upload = "success", missing = "stale", join = "idle"),
  locked = "join", locked_tips = c(join = "還不能用：先加入至少 2 個檔案")
)
}
