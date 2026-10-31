% English translation of man/kit_button.Rd (roxygen2 output of R/buttons.R). Update by hand when the Chinese changes.
\name{kit_button}
\alias{kit_button}
\title{Button}
\usage{
kit_button(id, label, kind = "secondary", ..., class = NULL)
}
\arguments{
\item{id}{The button's input id.}

\item{label}{The text on the button.}

\item{kind}{\code{"primary"}, \code{"secondary"}, or \code{"danger"}.}

\item{...}{Other arguments passed to \code{\link[shiny:actionButton]{shiny::actionButton()}} (e.g. \code{disabled = TRUE}, \code{icon}).}

\item{class}{An extra class.}
}
\value{
\verb{<button class="btn ...">}.
}
\description{
A \code{\link[shiny:actionButton]{shiny::actionButton()}} with a class set by the button kind:
}
\details{
\itemize{
\item \code{"primary"}: primary button, lime background, large text, card shadow. One per page, plus the "下一步" ("Next step") at the bottom.
\item \code{"secondary"}: secondary button, white background, thin border, no shadow. For download, select all, example files, move up/down, copy.
\item \code{"danger"}: danger button, salmon background. For delete, remove, skip this round.
}

For a regular button (white background, black border, small shadow, e.g. "對，下一步" ("Yes, next step")) use \code{shiny::actionButton()} directly.
Start the text with a verb and say clearly what pressing it does; if it leaves the page, add "→" after the text.
}
\examples{
kit_button("run", "執行串接", "primary")       # "Run join"
kit_button("all", "全選")                     # "Select all"
kit_button("drop", "這一回合不做", "danger")  # "Skip this round"
}
