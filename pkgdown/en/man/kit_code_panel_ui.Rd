% English translation of man/kit_code_panel_ui.Rd (roxygen2 output of R/modules.R). Update by hand when the Chinese changes.
\name{kit_code_panel_ui}
\alias{kit_code_panel_ui}
\alias{kit_code_panel_server}
\title{"How to do it in R" module (code panel)}
\usage{
kit_code_panel_ui(id, title = "用 R 怎麼做", open = FALSE)

kit_code_panel_server(
  id,
  code,
  note = KIT_CODE_NOTE,
  width = KIT_CODE_WIDTH,
  empty = KIT_CODE_EMPTY
)
}
\arguments{
\item{id}{The module id.}

\item{title}{The collapsible title.}

\item{open}{Whether it starts open.}

\item{code}{A function or reactive returning the code: a string, a \code{\link[=kit_code]{kit_code()}}, or a named list of them
(see \code{snips} in \code{\link[=kit_code_blocks]{kit_code_blocks()}}).}

\item{note, width, empty}{See \code{\link[=kit_render_code_panel]{kit_render_code_panel()}}.}
}
\value{
\code{kit_code_panel_ui()}: \verb{<details class="kit-detail">}, placed last in \code{\link[=kit_details_row]{kit_details_row()}}.

\code{kit_code_panel_server()}: a reactive with the current code (a list of \code{\link[=kit_code]{kit_code()}}; \code{NULL} when there is none yet).
}
\description{
A collapsible block in the details row; the code is computed only when it is opened (Shiny does not render outputs inside a collapsed block),
and rendered as one or more \code{\link[=kit_code]{kit_code()}} (at most 70 columns per line, with "Copy").
}
\examples{
if (interactive()) {
  ui <- kit_page("KIT 示範", NULL, kit_details_row(kit_code_panel_ui("code")))
  server <- function(input, output, session) {
    kit_code_panel_server("code", function() list(tidy = "x <- 1", base = "x <- 1"))
  }
  shiny::shinyApp(ui, server)
}
}
\seealso{
\code{\link[=kit_code_panel]{kit_code_panel()}}, \code{\link[=kit_render_code_panel]{kit_render_code_panel()}} (low level)
}
