% English translation of man/kit_status.Rd (roxygen2 output of R/status.R). Update by hand when the Chinese changes.
\name{kit_status}
\alias{kit_status}
\alias{as.tags.kit_status}
\alias{format.kit_status}
\alias{print.kit_status}
\title{Status object (status box)}
\usage{
kit_status(
  state = "idle",
  message = "",
  warnings = character(0),
  notes = character(0),
  details = NULL,
  action = NULL,
  points = character(0),
  details_title = "原始訊息"
)

\method{as.tags}{kit_status}(x, ...)

\method{format}{kit_status}(x, ...)

\method{print}{kit_status}(x, ...)
}
\arguments{
\item{state}{\code{"idle"}, \code{"success"}, \code{"warning"}, \code{"error"}, or \code{"stale"}.}

\item{message}{The conclusion on the first line (one sentence, with numbers and units): a string or tag.}

\item{warnings}{Things to watch out for (a character vector, or a list of strings and tags). Listed first.}

\item{notes}{Additional notes (small gray text).}

\item{details}{The raw message (R's original error text; collapsed): a string or \code{NULL}.}

\item{action}{A button or link for what to do (a tag); \code{NULL} shows nothing.}

\item{points}{Key results (listed after \code{warnings}; they do not turn the status into "請注意", "please note").}

\item{details_title}{The collapsible title for the raw message (kitsUI uses "kits 的原文", "kits' original text").}

\item{x}{A \code{kit_status} object.}

\item{...}{Other content for \code{\link[=kit_status_ui]{kit_status_ui()}} (as.tags); not used by format and print.}
}
\value{
A \code{kit_status} object.
}
\description{
The result of an action. This is an S3 value object (class \code{kit_status}): its content is checked when it is built.
It has an \code{\link[htmltools:as.tags]{htmltools::as.tags()}} method, so \code{renderUI(st)} or putting it straight into \code{tagList()} renders it as a status box
(the same as \code{\link[=kit_status_ui]{kit_status_ui()}}). \code{print(st)} prints a text version.
}
\details{
Each of the four states has a fixed label and color:\tabular{lll}{
   state \tab Label \tab Background \cr
   \code{"success"} \tab 【完成】 ("Done") \tab mint green \cr
   \code{"warning"} \tab 【完成，但請注意】 ("Done, but please note") \tab yellow \cr
   \code{"error"} \tab 【停下來】 ("Stopped") \tab salmon \cr
   \code{"stale"} \tab 【要重新執行】 ("Run again") \tab yellow \cr
}


\code{"idle"} (not run yet) is not shown. kitsUI's names are also accepted: \code{"done"}, \code{"warn"}, \code{"stop"}.
}
\examples{
st <- kit_status("success", "串接完成：結果共 3,389 列 × 2,058 欄。")
st
htmltools::as.tags(st)
}
\seealso{
\code{\link[=kit_status_ui]{kit_status_ui()}}, \code{\link[=kit_done_status]{kit_done_status()}}, \code{\link[=kit_error_status]{kit_error_status()}}, \code{\link[=kit_stale_status]{kit_stale_status()}}
}
