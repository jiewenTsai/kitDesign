% English translation of man/kit_plotly_fonts.Rd (roxygen2 output of R/plotly.R). Update by hand when the Chinese changes.
\name{kit_plotly_fonts}
\alias{kit_plotly_fonts}
\title{Attach the app's typeface to a plotly chart (for downloaded HTML)}
\usage{
kit_plotly_fonts(p)
}
\arguments{
\item{p}{A plotly chart (or another htmlwidget).}
}
\value{
The same chart, with one more htmlDependency (\code{kit-plotly-fonts}).
}
\description{
Attaches an htmlDependency to a plotly chart that loads the rounded typeface Chiron GoRound TC from Google Fonts
(weights 400 and 700). Shiny pages already have this typeface (\code{\link[=kit_theme]{kit_theme()}}), so this is mainly for
single HTML files saved with \code{htmlwidgets::saveWidget()}: they also open in the app's typeface; without a network
connection they fall back to the system sans-serif.
}
\details{
The \verb{<link>} carries \code{data-external="1"}: when \code{saveWidget(selfcontained = TRUE)} bundles the file with pandoc,
the font files are not embedded in the HTML (a Chinese typeface is split into hundreds of files, so embedding them would make the file very large).
\code{\link[=kit_plotly_style]{kit_plotly_style()}} already calls it by default (\code{fonts = TRUE}); attaching it twice to the same chart is the same as attaching it once.
}
\examples{
if (requireNamespace("plotly", quietly = TRUE)) {
  p <- kit_plotly_fonts(plotly::plot_ly(x = 1:3, y = c(2, 4, 3), type = "scatter", mode = "lines"))
  vapply(p$dependencies, function(d) d$name, "")
}
}
\seealso{
\code{\link[=kit_plotly_style]{kit_plotly_style()}}
}
