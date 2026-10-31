% English translation of man/kit_num.Rd (roxygen2 output of R/tables.R). Update by hand when the Chinese changes.
\name{kit_num}
\alias{kit_num}
\title{Integer with thousands separators}
\usage{
kit_num(x)
}
\arguments{
\item{x}{A number (or a string that can be converted to a number).}
}
\value{
A string, for example \code{"3,418"}.
}
\description{
KIT design language: numbers with four or more digits get thousands separators, as in "3,389 人" ("3,389 people"). Decimals are rounded to integers.
}
\examples{
kit_num(3418)
kit_num(c(5, 12345, 1e6))
}
