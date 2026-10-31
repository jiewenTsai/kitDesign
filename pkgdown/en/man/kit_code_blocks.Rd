% English translation of man/kit_code_blocks.Rd (roxygen2 output of R/code.R). Update by hand when the Chinese changes.
\name{kit_code_blocks}
\alias{kit_code_blocks}
\title{Content of "How to do it in R": a note plus code in one or more versions (with "Copy")}
\usage{
kit_code_blocks(snips, note = KIT_CODE_NOTE, width = KIT_CODE_WIDTH)
}
\arguments{
\item{snips}{The code: a string, a \code{\link[=kit_code]{kit_code()}} object, or a named list / character vector of them
(names are version names). kitJoin's \code{list(tidy = , base = )} is labeled "tidyverse 版" ("tidyverse version") and "base R 版" ("base R version");
\code{NULL} versions are skipped (e.g. with \code{base = NULL} there is only the tidyverse version). Without names the version name is "R".}

\item{note}{A one-line note at the top; \code{NULL} shows nothing.}

\item{width}{Maximum columns per line; \code{NULL} means no wrapping and no check.}
}
\value{
\code{\link[htmltools:tagList]{htmltools::tagList()}}.
}
\description{
Each version is a \code{\link[=kit_code]{kit_code()}}: a line with "version name (bold) + Copy" and the code box below it;
two versions are stacked vertically. Code lines are at most 70 columns (\code{\link[=kit_code_wrap]{kit_code_wrap()}}); ligatures are always turned off.
}
\examples{
kit_code_blocks(list(
  tidy = "joined <- dplyr::left_join(t1, t2, by = \"id\")",
  base = "joined <- merge(t1, t2, by = \"id\", all.x = TRUE)"
))
kit_code_blocks(c("kits 版" = "fit <- kits::kits_calibrate(resp)"))  # "kits version"
}
