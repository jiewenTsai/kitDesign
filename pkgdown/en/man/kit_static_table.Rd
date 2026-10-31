% English translation of man/kit_static_table.Rd (roxygen2 output of R/tables.R). Update by hand when the Chinese changes.
\name{kit_static_table}
\alias{kit_static_table}
\title{Small table (put directly inside renderUI(); no separate output needed)}
\usage{
kit_static_table(df, class = "table table-sm table-striped")
}
\arguments{
\item{df}{A data.frame.}

\item{class}{The table's class.}
}
\value{
\verb{<table class="table table-sm table-striped">}.
}
\description{
White background, black header with white text, zebra stripes, width fits the content. Integer columns get thousands separators automatically (3389 → 3,389).
Put an \code{h4} title and a \code{\link[=kit_rows_note]{kit_rows_note()}} line above it.
}
\examples{
kit_static_table(data.frame(世代 = c("M03", "M36"), 人數 = c(3389, 1250)))
}
