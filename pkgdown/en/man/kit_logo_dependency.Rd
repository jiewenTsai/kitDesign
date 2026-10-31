% English translation of man/kit_logo_dependency.Rd (roxygen2 output of R/setup.R). Update by hand when the Chinese changes.
\name{kit_logo_dependency}
\alias{kit_logo_dependency}
\title{htmlDependency for the logo files (inst/logo/): the header SVG and tab icon are fetched by URL}
\usage{
kit_logo_dependency()
}
\value{
An \code{\link[htmltools:htmlDependency]{htmltools::htmlDependency()}} object; file URLs are \verb{kitDesign-logo-<version>/<file name>}
(\code{\link[=kit_logo_file]{kit_logo_file()}}).
}
\description{
htmlDependency for the logo files (inst/logo/): the header SVG and tab icon are fetched by URL.
}
\examples{
kit_logo_dependency()$name
}
