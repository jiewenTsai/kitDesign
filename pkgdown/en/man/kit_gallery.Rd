% English translation of man/kit_gallery.Rd (roxygen2 output of R/kitDesign-package.R). Update by hand when the Chinese changes.
\name{kit_gallery}
\alias{kit_gallery}
\title{Component gallery app}
\usage{
kit_gallery(..., brand = NULL)
}
\arguments{
\item{...}{Arguments passed to \code{\link[shiny:runApp]{shiny::runApp()}} (e.g. \code{port = 7551}, \code{launch.browser = FALSE}).}

\item{brand}{Which brand to view: \code{NULL} (default) is the current brand (\code{\link[=kit_current_brand]{kit_current_brand()}}, usually KIT);
\code{"demo"} is a blue demo brand (to see how a different brand looks); or a \code{\link[=kit_brand]{kit_brand()}}.}
}
\value{
The result of \code{\link[shiny:runApp]{shiny::runApp()}} (when the app closes).
}
\description{
One app holding every component, filled with KIT examples.
The source is in \code{system.file("examples/gallery", package = "kitDesign")}.
}
\examples{
if (interactive()) kit_gallery()
if (interactive()) kit_gallery(brand = "demo")
}
