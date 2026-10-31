% English translation of man/kit_steps.Rd (roxygen2 output of R/guide.R). Update by hand when the Chinese changes.
\name{kit_steps}
\alias{kit_steps}
\title{Numbered list of steps (for the \code{steps} of \code{\link[=kit_tab_guide]{kit_tab_guide()}})}
\usage{
kit_steps(...)
}
\arguments{
\item{...}{One string (or character vector) per step.}
}
\value{
\verb{<ol class="kit-steps">}.
}
\description{
Note: this is the \verb{<ol>} inside the guide box, not a step card; step cards are \code{\link[=kit_step_card]{kit_step_card()}}.
}
\examples{
kit_steps("選檔案", "選 ID 欄", "按「執行串接」")
}
