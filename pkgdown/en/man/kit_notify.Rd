% English translation of man/kit_notify.Rd (roxygen2 output of R/status.R). Update by hand when the Chinese changes.
\name{kit_notify}
\alias{kit_notify}
\title{Show a notification (Shiny's showNotification)}
\usage{
kit_notify(st, session = shiny::getDefaultReactiveDomain(), duration = NULL)
}
\arguments{
\item{st}{A \code{\link[=kit_status]{kit_status()}} object, or a string (a plain notification).}

\item{session}{The Shiny session (defaults to the current session).}

\item{duration}{How many seconds to show it; when \code{NULL}, the defaults above apply.}
}
\value{
The notification id (invisible); \code{NULL} for \code{"idle"} or when there is no session.
}
\description{
【停下來】 (stopped) is red and shows for 10 seconds; everything else uses the regular style and shows for 6 seconds.
}
\examples{
if (interactive()) {
  kit_notify(kit_done_status("串接完成。"))  # "Join done."
}
}
