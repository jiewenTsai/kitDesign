% English translation of man/kit_code_cols.Rd (roxygen2 output of R/code_wrap.R). Update by hand when the Chinese changes.
\name{kit_code_cols}
\alias{kit_code_cols}
\title{Display width of each line (CJK and full-width characters count as 2 columns)}
\usage{
kit_code_cols(x)
}
\arguments{
\item{x}{A character vector (one element per line).}
}
\value{
An integer vector: the number of columns in each line.
}
\description{
KIT code examples and notes are at most about 70 columns per line: Latin letters, digits, and symbols count as 1 column,
Chinese characters (and other full-width characters) count as 2.
}
\examples{
kit_code_cols(c("abc", "讀 CSV", ""))
# Which lines are wider than 70 columns
lines <- c("x <- 1", strrep("中", 36))
which(kit_code_cols(lines) > 70)
}
\seealso{
\code{\link[=kit_code_wrap]{kit_code_wrap()}}
}
