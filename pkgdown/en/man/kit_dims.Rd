% English translation of man/kit_dims.Rd (roxygen2 output of R/tables.R). Update by hand when the Chinese changes.
\name{kit_dims}
\alias{kit_dims}
\title{Dimension text: "5 列 × 7 欄" ("5 rows × 7 columns")}
\usage{
kit_dims(nrow, ncol, preview_cols = NULL)
}
\arguments{
\item{nrow, ncol}{Number of rows and columns.}

\item{preview_cols}{Give this when the screen previews only the first few columns (if fewer than the column count, adds "以下只預覽前 N 欄" ("previewing only the first N columns below")).}
}
\value{
A string.
}
\description{
Dimension text: "5 列 × 7 欄" ("5 rows × 7 columns").
}
\examples{
kit_dims(3418, 25)
kit_dims(3418, 25, preview_cols = 20)
}
