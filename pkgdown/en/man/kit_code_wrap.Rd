% English translation of man/kit_code_wrap.Rd (roxygen2 output of R/code_wrap.R). Update by hand when the Chinese changes.
\name{kit_code_wrap}
\alias{kit_code_wrap}
\title{Wrap code to at most 70 columns per line}
\usage{
kit_code_wrap(code, width = KIT_CODE_WIDTH)
}
\arguments{
\item{code}{The code (a string; may have several lines, or be several strings).}

\item{width}{Maximum columns per line.}
}
\value{
A single string (returned as is when \code{code} has length 0).
}
\description{
"How to do it in R" wraps the code only right before showing it (\code{\link[=kit_code]{kit_code()}} does this automatically), so functions that generate code need not worry about width:
}
\details{
\itemize{
\item Comments: break at spaces or between Chinese characters; continuation lines also start with "# "; punctuation is not put at the start of a line.
\item Code: break after a comma inside parentheses, and align continuation lines just after that parenthesis (a line break inside parentheses is always valid R).
If the parenthesis was opened on an earlier line (e.g. \verb{mutate(} on its own line with the arguments on the next), continuation lines use the same indent as this line.
\item If a trailing comment makes the line too wide, it is moved above the line.
}

After wrapping, the code is parsed again: if the expression differs from the original (or the original did not parse), the code is left unchanged.
Places that cannot be broken (e.g. a very long string) are also left as is and scroll sideways in the code box.
}
\examples{
code <- paste0(
  "x <- c(\"M03\", \"M03\", \"M03\", \"M36\", \"M36\", \"M36\", ",
  "\"M48\", \"M48\", \"M60\", \"M60\")"
)
cat(kit_code_wrap(code))
}
\seealso{
\code{\link[=kit_code_cols]{kit_code_cols()}}, \code{\link[=kit_code]{kit_code()}}
}
