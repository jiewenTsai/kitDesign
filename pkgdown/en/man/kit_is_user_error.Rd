% English translation of man/kit_is_user_error.Rd (roxygen2 output of R/status.R). Update by hand when the Chinese changes.
\name{kit_is_user_error}
\alias{kit_is_user_error}
\title{Was the error thrown by \code{\link[=kit_abort]{kit_abort()}}?}
\usage{
kit_is_user_error(e)
}
\arguments{
\item{e}{The error (a condition).}
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Was the error thrown by \code{\link[=kit_abort]{kit_abort()}}?
}
\examples{
kit_is_user_error(tryCatch(kit_abort("x"), error = identity))
}
