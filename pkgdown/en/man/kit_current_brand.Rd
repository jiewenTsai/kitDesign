% English translation of man/kit_current_brand.Rd (roxygen2 output of R/brand.R). Update by hand when the Chinese changes.
\name{kit_current_brand}
\alias{kit_current_brand}
\title{The current brand: \code{options(kitDesign.brand = )}, KIT when not set}
\usage{
kit_current_brand()
}
\value{
A \code{kit_brand} object.
}
\description{
The default \code{brand} for kitDesign functions (\code{\link[=kit_page]{kit_page()}}, \code{\link[=kit_header]{kit_header()}}, \code{\link[=kit_theme]{kit_theme()}}, \code{\link[=kit_colors]{kit_colors()}},
\code{\link[=kit_chart_sequential]{kit_chart_sequential()}}, \code{\link[=kit_plotly_style]{kit_plotly_style()}}).
An app only needs to set \code{options(kitDesign.brand = kit_brand(...))} once at startup.
}
\examples{
kit_current_brand()$name
}
\seealso{
\code{\link[=kit_brand]{kit_brand()}}
}
