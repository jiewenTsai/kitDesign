% English translation of man/kit_done_status.Rd (roxygen2 output of R/status.R). Update by hand when the Chinese changes.
\name{kit_done_status}
\alias{kit_done_status}
\title{Status after a run: 【完成，但請注意】 (done, but take note) when something needs attention, otherwise 【完成】 (done)}
\usage{
kit_done_status(
  message,
  warnings = character(0),
  notes = character(0),
  points = character(0)
)
}
\arguments{
\item{message}{The conclusion on the first line (one sentence, with numbers and units): a string or tag.}

\item{warnings}{Things that need attention (a character vector, or a list of strings and tags). Listed first.}

\item{notes}{Extra notes (small gray text).}

\item{points}{Key points of the result (listed after \code{warnings}; they do not turn the status into "take note").}
}
\value{
A \code{kit_status} object.
}
\description{
Anything unusual must be seen: when there are \code{warnings}, the status cannot be a plain 【完成】 (done).
}
\examples{
kit_done_status("串接完成：3,389 人。")  # "Join done: 3,389 children."
kit_done_status("串接完成：3,389 人。", warnings = "有 12 人的 ID 重複，只留第一筆。")
# warning: "12 children have duplicate IDs; only the first record is kept."
}
