% English translation of man/kit_logo_uri.Rd (roxygen2 output of R/setup.R). Update by hand when the Chinese changes.
\name{kit_logo_uri}
\alias{kit_logo_uri}
\title{KIT logo (data URI)}
\usage{
kit_logo_uri(size = 96, kind = c("mark", "logo"))
}
\arguments{
\item{size}{Pixels: the bean (\code{"mark"}) comes in 64, 96, 256, \code{"h512"}, \code{"h1024"}; the full logo (\code{"logo"},
bean plus KIT wordmark) comes in 128, 192, \code{"h512"}, \code{"h1024"} (height). The header uses the vector logo
(\code{\link[=kit_logo_file]{kit_logo_file()}}); this function gives a PNG to embed in the page.}

\item{kind}{\code{"mark"} is the bean only (browser tab icon); \code{"logo"} is the full logo (header).}
}
\value{
\code{"data:image/png;base64,..."}; \code{""} when that size does not exist.
}
\description{
Goes straight into the page (no static file path to set up). The logos are transparent PNGs in \verb{inst/logo/}.
}
\examples{
substr(kit_logo_uri(64), 1, 30)
}
