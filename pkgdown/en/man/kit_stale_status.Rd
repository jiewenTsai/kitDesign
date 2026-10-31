% English translation of man/kit_stale_status.Rd (roxygen2 output of R/status.R). Update by hand when the Chinese changes.
\name{kit_stale_status}
\alias{kit_stale_status}
\title{Old result no longer valid after files or settings change (【要重新執行】, "Run again")}
\usage{
kit_stale_status(run_label, message = NULL)
}
\arguments{
\item{run_label}{The primary button's text, for example "執行串接" ("Run join").}

\item{message}{Your own sentence (the default is "檔案或設定改過了，舊的結果已清除：請再按一次「…」。", "Files or settings changed and the old result was cleared: press '…' again.").}
}
\value{
A \code{kit_status} object.
}
\description{
Old result no longer valid after files or settings change (【要重新執行】, "Run again").
}
\examples{
kit_stale_status("執行串接")$message
}
