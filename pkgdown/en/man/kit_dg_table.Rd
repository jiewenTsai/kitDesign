% English translation of man/kit_dg_table.Rd (roxygen2 output of R/guide.R). Update by hand when the Chinese changes.
\name{kit_dg_table}
\alias{kit_dg_table}
\title{Small table for diagrams (2–3 columns, 2–4 rows)}
\usage{
kit_dg_table(df, title, added = NULL, row_header = FALSE)
}
\arguments{
\item{df}{A data.frame (values are converted to text); \code{NA} or \code{""} shows as "（空）" ("(empty)").}

\item{title}{The table name, placed in \verb{<caption>} (e.g. "第 1 波（t1）" ("Wave 1 (t1)"), "結果" ("Result")).}

\item{added}{Names of columns added in this step (e.g. \code{wave}).}

\item{row_header}{Whether column 1 holds row headers (\verb{<th scope="row">}).}
}
\value{
\verb{<table class="kit-dg-table">}.
}
\description{
A supporting element: no box, table as wide as its content, 1px thin lines, a light header (not the black header of large data tables);
values in a monospace font. New columns get a light lime background and "（新）" ("(new)") after the name, so it does not rely on color alone;
empty cells show a gray "（空）" ("(empty)").
}
\examples{
kit_dg_table(data.frame(id = 1:2, score = c(3, NA)), "第 1 波（t1）")  # "Wave 1 (t1)"
}
