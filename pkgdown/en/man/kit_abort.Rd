% English translation of man/kit_abort.Rd (roxygen2 output of R/status.R). Update by hand when the Chinese changes.
\name{kit_abort}
\alias{kit_abort}
\title{An error meant for the user}
\usage{
kit_abort(..., class = NULL, data = list())
}
\arguments{
\item{...}{The message (joined with \code{paste0()}).}

\item{class}{An extra condition class (the caller can handle it separately, e.g. to show a confirmation dialog).}

\item{data}{Other fields to attach to the condition (a named list).}
}
\value{
Does not return: throws a \code{kit_user_error} error.
}
\description{
The message should be plain-language Chinese that says what went wrong and how to fix it;
\code{\link[=kit_error_status]{kit_error_status()}} shows it as written in the status box, with no technical details.
Any other, unexpected error is wrapped as "…時發生沒有預期到的問題" ("an unexpected problem occurred while …"),
with the original message tucked away.
}
\examples{
e <- tryCatch(kit_abort("至少要 ", 2, " 個波次的檔案。"), error = identity)  # "Need files from at least 2 waves."
class(e)
conditionMessage(e)
}
