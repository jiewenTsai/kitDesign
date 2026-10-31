% English translation of man/kit_code_panel.Rd (roxygen2 output of R/code.R). Update by hand when the Chinese changes.
\name{kit_code_panel}
\alias{kit_code_panel}
\title{Placeholder for "How to do it in R" (code panel)}
\usage{
kit_code_panel(output_id, title = "用 R 怎麼做", open = FALSE)
}
\arguments{
\item{output_id}{The \code{uiOutput()} id that holds the content (wrap in \code{ns()} inside a module).}

\item{title}{The collapsible title.}

\item{open}{Whether it starts open (collapsed by default).}
}
\value{
\verb{<details class="kit-detail">}.
}
\description{
A \code{\link[=kit_detail]{kit_detail()}} inside the details row (\code{\link[=kit_details_row]{kit_details_row()}}), collapsed by default; the server fills
\code{output_id} with \code{\link[=kit_render_code_panel]{kit_render_code_panel()}}. With modules, use \code{\link[=kit_code_panel_ui]{kit_code_panel_ui()}}.
}
\examples{
kit_details_row(kit_detail("預覽", "…"), kit_code_panel("code"))  # "Preview"
}
