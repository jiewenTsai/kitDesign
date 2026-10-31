% English translation of man/kit_chart_colors.Rd (roxygen2 output of R/tables.R). Update by hand when the Chinese changes.
\name{kit_chart_colors}
\alias{kit_chart_colors}
\title{Categorical chart colors}
\usage{
kit_chart_colors(n = NULL)
}
\arguments{
\item{n}{When \code{NULL}, returns all 6 (named); when a number, takes the first \code{n} in order (unnamed).}
}
\value{
A character vector of colors.
}
\description{
Colorblind-friendly Okabe–Ito. Cohorts, scales, and scores take colors in order: blue, orange, green, reddish purple, sky blue, vermillion;
past 6 categories it starts over. For reference lines, bands, and points with no judgment, use \code{\link[=kit_chart_neutral]{kit_chart_neutral()}}.
}
\examples{
kit_chart_colors()
kit_chart_colors(3)
}
