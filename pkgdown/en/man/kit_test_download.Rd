% English translation of man/kit_test_download.Rd (roxygen2 output of R/download.R). Update by hand when the Chinese changes.
\name{kit_test_download}
\alias{kit_test_download}
\title{Press a download button in tests}
\usage{
kit_test_download(session, id, write = TRUE)
}
\arguments{
\item{session}{The \code{session} of \code{testServer()}.}

\item{id}{The button id: inside a module, the id without namespace (\code{"dl"}); at the app level, the full id
(\code{"stack-download_csv"}).}

\item{write}{When \code{FALSE}, no file is written and no response is made; only the file name registered is checked (for example, downloads that are slow to draw a chart).}
}
\value{
\code{\link[shiny:httpResponse]{shiny::httpResponse()}} (\code{status}, \code{content_type}, \code{headers}, \code{content$file}),
with one more field \code{filename}: the file name registered. With \code{write = FALSE}, only \code{list(filename = )}.
}
\description{
The mock session of \code{\link[shiny:testServer]{shiny::testServer()}} does not really register downloads (\code{registerDataObj()} does nothing), so
\code{\link[=kit_download_button]{kit_download_button()}} stores the download in \code{session$userData} instead; this function takes it from there and writes the file
and responds the same way as when a browser presses download.
}
\examples{
session <- shiny::MockShinySession$new()
b <- kit_download_button(session, "dl", "下載", "a.csv", function(file) writeLines("x", file))
res <- kit_test_download(session, "dl")
res$content_type
readLines(res$content$file)
}
