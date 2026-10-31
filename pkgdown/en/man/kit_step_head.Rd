% English translation of man/kit_step_head.Rd (roxygen2 output of R/steps.R). Update by hand when the Chinese changes.
\name{kit_step_head}
\alias{kit_step_head}
\title{Step card header}
\usage{
kit_step_head(
  k,
  title,
  state = c("current", "done", "locked"),
  summary = NULL,
  edit_id = NULL,
  title_id = NULL
)
}
\arguments{
\item{k}{The step number.}

\item{title}{The title of this step.}

\item{state}{\code{"current"}, \code{"done"}, or \code{"locked"}.}

\item{summary}{A one-sentence summary shown when done (for example "5 個檔案 · 世代 TDCYP · 2009、2011（年）", "5 files · cohort TDCYP · 2009, 2011 (year)").
Not shown for the current step; a step not yet available always shows "先完成第 N−1 步" ("Finish step N−1 first").}

\item{edit_id}{The \code{actionLink()} id for "改" ("Edit") when done; \code{NULL} hides "改".}

\item{title_id}{The id of the title (pass it to the \code{title_id} of \code{\link[=kit_step_card]{kit_step_card()}}).}
}
\value{
\verb{<div class="kit-stephead is-current">} or similar.
}
\description{
Three states:
}
\details{
\itemize{
\item \code{"current"}: the current step, a lime round number, \code{aria-current="step"}.
\item \code{"done"}: finished, a round ✓ (mint green), followed by a one-sentence summary, with "改" ("Edit") at the far right (when \code{edit_id} is given).
\item \code{"locked"}: not yet available, gray, showing "先完成第 N−1 步" ("Finish step N−1 first").
}

Next to the number there is text for screen readers: "第 N 步，現在這一步：" ("Step N, current step:").
}
\examples{
kit_step_head(1, "每個檔案是哪個世代、哪個波次", "done",
              summary = "5 個檔案 · 世代 TDCYP", edit_id = "edit1")
kit_step_head(2, "哪些欄是題目", "locked")
}
