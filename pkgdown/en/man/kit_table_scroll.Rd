% English translation of man/kit_table_scroll.Rd (roxygen2 output of R/tables.R). Update by hand when the Chinese changes.
\name{kit_table_scroll}
\alias{kit_table_scroll}
\title{Put wide tables in here: they scroll sideways in their own box and do not break the layout}
\usage{
kit_table_scroll(..., tall = FALSE)
}
\arguments{
\item{...}{Tables (for example \code{\link[=kit_static_table]{kit_static_table()}} or \code{shiny::tableOutput()}).}

\item{tall}{For long tables: fixed height (about 26rem), with the header fixed at the top.}
}
\value{
\verb{<div class="kit-table-scroll">}.
}
\description{
Put wide tables in here: they scroll sideways in their own box and do not break the layout.
}
\examples{
kit_table_scroll(kit_static_table(data.frame(id = 1:3)))
}
