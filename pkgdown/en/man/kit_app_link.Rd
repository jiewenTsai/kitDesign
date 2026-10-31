% English translation of man/kit_app_link.Rd (roxygen2 output of R/buttons.R). Update by hand when the Chinese changes.
\name{kit_app_link}
\alias{kit_app_link}
\title{A link to another website or app (opens in a new tab)}
\usage{
kit_app_link(label, href, kind = "link", class = NULL, note = NULL)
}
\arguments{
\item{label}{The link text, e.g. "開啟 kitsUI" ("Open kitsUI").}

\item{href}{The URL.}

\item{kind}{\code{"link"} (a text link) or a button kind (\code{"secondary"}, \code{"primary"}).}

\item{class}{An extra class for the link (e.g. \code{"kit-next-link"}).}

\item{note}{A line of small print after it, e.g. "（開啟網路上的雲端版 kitsUI）" ("(opens the online cloud version of kitsUI)"); \code{NULL} shows nothing.}
}
\value{
\verb{<span class="kit-app-link">}.
}
\description{
For example, a link from kitJoin to the cloud version of kitsUI. The link opens in a new tab
(\code{target="_blank"}) and can be followed by a line of small print saying where it goes.
Whether to show the link (local version, cloud version) is up to the app.
}
\examples{
kit_app_link("開啟 kitsUI", "https://example.org/kitsui/", kind = "secondary",
             note = "（開啟網路上的雲端版 kitsUI）")
}
