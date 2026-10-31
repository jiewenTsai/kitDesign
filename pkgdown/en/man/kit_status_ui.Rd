% English translation of man/kit_status_ui.Rd (roxygen2 output of R/status.R). Update by hand when the Chinese changes.
\name{kit_status_ui}
\alias{kit_status_ui}
\title{Status box}
\usage{
kit_status_ui(st, ..., max_points = KIT_STATUS_MAX_POINTS)
}
\arguments{
\item{st}{A \code{\link[=kit_status]{kit_status()}} object (a list with the same fields, from older apps, also works); \code{NULL} or \code{"idle"} shows nothing.}

\item{...}{Other content placed last inside the box (kitsUI's \code{ui_status(...)}).}

\item{max_points}{How many points to list directly (default 3).}
}
\value{
\verb{<div class="alert alert-success kit-status" role="alert">} or similar; \code{NULL} when nothing is shown.
}
\description{
Renders a \code{\link[=kit_status]{kit_status()}} as a status box: the first line is the label plus a one-sentence conclusion; then up to 3 points
(things to watch out for first, key results after), the rest collapsed under "還有 N 點" ("N more points"); a button for what to do;
small additional notes; the collapsed raw message. After running, use \code{\link[=kit_scroll_to]{kit_scroll_to()}} to scroll it to the top of the screen.
}
\details{
A \code{kit_status} object can also go straight into the page (its \code{\link[htmltools:as.tags]{htmltools::as.tags()}} method is this function);
you only need to call this function to add more content or change the number of points.
}
\examples{
kit_status_ui(kit_done_status(
  "串接完成：結果共 3,389 列 × 2,058 欄。",
  warnings = c("有 12 人的 ID 重複。", "第 3 波沒有 sex 欄。"),
  points = c("688 人每個檔案都有資料。", "第 1 波 3,389 人。")
))
}
