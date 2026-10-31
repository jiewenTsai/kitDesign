% English translation of man/kit_settings_line.Rd (roxygen2 output of R/details.R). Update by hand when the Chinese changes.
\name{kit_settings_line}
\alias{kit_settings_line}
\title{Settings summary: a line of small text above the primary button or the result}
\usage{
kit_settings_line(parts, prefix = "本次：")
}
\arguments{
\item{parts}{The parts of the text (empty strings, \code{NA}, and \code{NULL} are skipped), joined with " · ";
can also be a complete sentence written beforehand (kitsUI's \code{ui_settings_line(text)}; in that case use \code{prefix = NULL}).}

\item{prefix}{The text in front, default "本次：" ("This run:"); \code{NULL} adds nothing.}
}
\value{
\verb{<p class="kit-settings-line">}; \code{NULL} when there are no parts.
}
\description{
For example "本次：5 個檔案 · ID：各檔各自 · 全勤樣本" ("This run: 5 files · ID: per file · complete-attendance sample").
}
\examples{
kit_settings_line(c("5 個檔案", "ID：各檔各自", "全勤樣本"))
kit_settings_line("本回合 R1：M03、M36 · 參照世代 M03", prefix = NULL)
}
