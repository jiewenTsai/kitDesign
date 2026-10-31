% English translation of man/kit_step_card.Rd (roxygen2 output of R/steps.R). Update by hand when the Chinese changes.
\name{kit_step_card}
\alias{kit_step_card}
\title{Step card}
\usage{
kit_step_card(head, ..., title_id = NULL)
}
\arguments{
\item{head}{The header: \code{\link[=kit_step_head]{kit_step_head()}}, or the \code{uiOutput()} that holds it.}

\item{...}{The card content (\code{\link[=kit_step_body]{kit_step_body()}}).}

\item{title_id}{The id of the header title (the \code{title_id} of \code{\link[=kit_step_head]{kit_step_head()}}), used by screen readers as the card name.}
}
\value{
\verb{<section class="kit-stepcard">}.
}
\description{
One card: on top is \code{\link[=kit_step_head]{kit_step_head()}} (usually rendered by the server based on the state, in a \code{uiOutput()}),
below is the content of this step (\code{\link[=kit_step_body]{kit_step_body()}}, usually wrapped in \code{conditionalPanel()} so only the current step is open).
The card's border and shadow follow the header's state: the current step has a border and shadow; finished steps and steps not yet available have no shadow and a gray border.
}
\details{
If you do not want to manage which step is open yourself, use the module \code{\link[=kit_stepcards_ui]{kit_stepcards_ui()}} / \code{\link[=kit_stepcards_server]{kit_stepcards_server()}}.
}
\examples{
kit_step_card(
  kit_step_head(1, "每個檔案是哪個世代、哪個波次", "current", title_id = "steptitle1"),
  kit_step_body(shiny::p("已經照欄名猜好了，請看一遍。"),
                shiny::actionButton("ok1", "對，下一步")),
  title_id = "steptitle1"
)
}
