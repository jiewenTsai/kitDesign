% English translation of man/kit_checklist.Rd (roxygen2 output of R/steps.R). Update by hand when the Chinese changes.
\name{kit_checklist}
\alias{kit_checklist}
\alias{as.tags.kit_checklist}
\alias{format.kit_checklist}
\alias{print.kit_checklist}
\title{Checklist}
\usage{
kit_checklist(...)

\method{as.tags}{kit_checklist}(x, ...)

\method{format}{kit_checklist}(x, ...)

\method{print}{kit_checklist}(x, ...)
}
\arguments{
\item{...}{\code{\link[=kit_check]{kit_check()}} items, or a list of them (\code{NULL} is skipped).}

\item{x}{A \code{kit_checklist} object.}
}
\value{
A \code{kit_checklist} object.
}
\description{
Lists "things to decide" together with "things already fine", placed before a conversion or run.
An S3 value object (class \code{kit_checklist}, a list of \code{\link[=kit_check]{kit_check()}}): put it straight into a page and it renders as
\verb{<ul class="kit-checklist">}, one item per row, with the faintest line between rows.
}
\examples{
cl <- kit_checklist(
  kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。",
            actions = kit_button("shift", "全部減 1（建議）")),
  kit_check("ok", "沒有疑似遺漏值代碼"),
  kit_check("note", "有 2 題沒有人作答，不會放進作答檔")
)
# todo: "3 items have scores starting at 1" / "kits needs scores 0, 1, 2…" / button "Subtract 1 from all (recommended)"
# ok:   "No suspected missing-value codes"
# note: "2 items have no responses and will not go into the response file"
cl
htmltools::as.tags(cl)
}
