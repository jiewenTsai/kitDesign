% English translation of man/kit_step_body.Rd (roxygen2 output of R/steps.R). Update by hand when the Chinese changes.
\name{kit_step_body}
\alias{kit_step_body}
\title{Step card content}
\usage{
kit_step_body(...)
}
\arguments{
\item{...}{The content of this step; usually ends with "對，下一步" ("Yes, next step") (\code{shiny::actionButton()}, a regular button).}
}
\value{
\verb{<div class="kit-stepbody">}.
}
\description{
Tables inside the card have no outer border and a light header (CSS handles this); no indent on phones.
}
\examples{
kit_step_body(shiny::p("說明"), shiny::actionButton("ok1", "對，下一步"))
}
