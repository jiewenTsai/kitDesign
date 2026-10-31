% English translation of man/kit_details_row.Rd (roxygen2 output of R/details.R). Update by hand when the Chinese changes.
\name{kit_details_row}
\alias{kit_details_row}
\title{Details row}
\usage{
kit_details_row(...)
}
\arguments{
\item{...}{\code{\link[=kit_detail]{kit_detail()}} (or \code{\link[=kit_code_panel]{kit_code_panel()}}).}
}
\value{
\verb{<div class="kit-details">}.
}
\description{
A row of collapsed small-print titles below the result (▸ 預覽 ▸ 這一回合的紀錄 ▸ 用 R 怎麼做;
"Preview", "Log for this round", "How to do it in R"). The one that is open takes a full line, and its content has no box.
"用 R 怎麼做" ("How to do it in R") always goes last.
}
\examples{
kit_details_row(
  kit_detail("預覽", "前 10 列"),
  kit_detail("這一回合的紀錄", "沒有提醒。")
)
# "Preview" / "First 10 rows"; "Log for this round" / "No notes."
}
