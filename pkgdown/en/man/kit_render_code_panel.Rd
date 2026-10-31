% English translation of man/kit_render_code_panel.Rd (roxygen2 output of R/code.R). Update by hand when the Chinese changes.
\name{kit_render_code_panel}
\alias{kit_render_code_panel}
\title{Server side: render code into \code{\link[=kit_code_panel]{kit_code_panel()}}}
\usage{
kit_render_code_panel(
  code,
  note = KIT_CODE_NOTE,
  width = KIT_CODE_WIDTH,
  empty = KIT_CODE_EMPTY
)
}
\arguments{
\item{code}{A function or reactive that returns the code: the \code{snips} of \code{\link[=kit_code_blocks]{kit_code_blocks()}}.}

\item{note, width}{See \code{\link[=kit_code_blocks]{kit_code_blocks()}}.}

\item{empty}{The one line shown while there is no code yet.}
}
\value{
\code{\link[shiny:renderUI]{shiny::renderUI()}}.
}
\description{
\code{output[["code"]] <- kit_render_code_panel(function() code_text())}.
Nothing is computed while the panel is collapsed (Shiny does not render hidden outputs; it computes only when "用 R 怎麼做" ("How to do it in R") is opened). When \code{code()} stops
(\code{req()}), fails, or is empty, only the \code{empty} line is shown.
}
\examples{
if (interactive()) {
  server <- function(input, output, session) {
    output$code <- kit_render_code_panel(function() "x <- 1")
  }
}
}
