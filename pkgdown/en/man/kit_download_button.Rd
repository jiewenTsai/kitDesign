% English translation of man/kit_download_button.Rd (roxygen2 output of R/download.R). Update by hand when the Chinese changes.
\name{kit_download_button}
\alias{kit_download_button}
\title{Download button}
\usage{
kit_download_button(
  session,
  id,
  label,
  filename,
  content,
  class = NULL,
  app = getOption("kitDesign.app", "kit")
)
}
\arguments{
\item{session}{The module's session (the namespace is added to the id automatically).}

\item{id}{The button id (without namespace).}

\item{label}{The button text, e.g. "下載 CSV" ("Download CSV").}

\item{filename}{The download file name (a string; may contain Chinese and spaces).}

\item{content}{\verb{function(file)}: writes the file to \code{file}.}

\item{class}{An extra class, e.g. \code{kit_btn_class("secondary")}, \code{"btn-primary"}.}

\item{app}{The app name: used in log messages; when the file name is all Chinese, the ASCII fallback name for old browsers is its lowercase form
("第一波.csv" → "kitjoin.csv"). Defaults to \code{getOption("kitDesign.app", "kit")}:
the app sets it once in \code{.onLoad()}.}
}
\value{
\verb{<a class="btn btn-default kit-download" download="檔名">} (\code{download} holds the file name).
}
\description{
Looks the same as \code{\link[shiny:downloadButton]{shiny::downloadButton()}}, but Chinese file names save correctly in every browser: the last part of the URL,
the \code{Content-Disposition} header (\code{filename} and \verb{filename*}), and \verb{<a download>} all carry the same file name.
Put it inside \code{renderUI()}: it is registered again on each redraw, the URL changes with it, and you never get a stale file.
}
\details{
The file is written only when the user clicks download (\code{content(file)}, which can read reactives). If writing fails: the error goes to the log
("\if{html}{\out{<app>}} 下載失敗（檔名）：…", "<app> download failed (file name): …"), this session shows a red notification (which does not disappear on its own),
and the response is 500 with the same sentence. Messages from \code{\link[=kit_abort]{kit_abort()}} are shown to the user as written; other errors do not expose internal messages.

\code{Content-Type} follows the extension: \code{.csv}, \code{.zip}, and \code{.html} get their own MIME types; everything else (\code{.sav}, \code{.csv.gz})
is \code{application/octet-stream}, so browsers that add an extension based on MIME type don't add an extra one.
}
\examples{
if (interactive()) {
  server <- function(input, output, session) {
    output$dl_ui <- shiny::renderUI(kit_download_button(
      session, "dl", "下載 CSV", "第一波 資料.csv",   # "Download CSV", "Wave 1 data.csv"
      function(file) utils::write.csv(mtcars, file)
    ))
  }
}
}
\seealso{
\code{\link[=kit_test_download]{kit_test_download()}} (for tests)
}
