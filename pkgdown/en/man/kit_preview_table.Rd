% English translation of man/kit_preview_table.Rd (roxygen2 output of R/tables.R). Update by hand when the Chinese changes.
\name{kit_preview_table}
\alias{kit_preview_table}
\title{Data for a preview table (pass to \code{shiny::renderTable()})}
\usage{
kit_preview_table(
  df,
  priority_cols = NULL,
  n = KIT_PREVIEW_ROWS,
  max_cols = KIT_PREVIEW_COLS
)
}
\arguments{
\item{df}{A data.frame.}

\item{priority_cols}{Columns that must be in the preview (for example the ID column); they go first.}

\item{n}{Maximum number of rows.}

\item{max_cols}{Maximum number of columns.}
}
\value{
A data.frame (all columns are text).
}
\description{
With too many columns, only the first \code{max_cols} columns are kept (\code{priority_cols} are kept first); only the first \code{n} rows are kept.
Each column is converted to easy-to-read text (value labels as "\verb{[value] label}", dates as yyyy-mm-dd).
Put a \code{\link[=kit_rows_note]{kit_rows_note()}} line above it.
}
\examples{
df <- as.data.frame(matrix(1:60, nrow = 2))
dim(kit_preview_table(df, priority_cols = "V30", n = 1))
}
