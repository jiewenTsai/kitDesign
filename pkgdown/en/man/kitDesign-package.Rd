% English translation of man/kitDesign-package.Rd (roxygen2 output of R/kitDesign-package.R). Update by hand when the Chinese changes.
\docType{package}
\name{kitDesign-package}
\alias{kitDesign}
\alias{kitDesign-package}
\title{kitDesign: the shared Shiny interface for KIT research tools}
\description{
The interface layer shared by kitJoin, kitsUI, and future KIT Shiny apps: the theme (\code{\link[=kit_theme]{kit_theme()}}),
styles and scripts (\code{\link[=use_kit]{use_kit()}}), the page (\code{\link[=kit_page]{kit_page()}}), and components built to the
"KIT design language" (\verb{kit_*()}). The design language lives in the \verb{brand/} folder of the package source.
}
\details{
A new app starts like this:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{library(kitDesign)
ui <- kit_page("KIT ×× 工具", "臺灣幼兒發展調查資料庫", version = "0.1.0", date = "2026-10-31",
  kit_tab_guide("這一頁做什麼。", kit_steps("第一步", "第二步"), "會得到什麼。")
)
}\if{html}{\out{</div>}}

(The strings are the app's on-screen Chinese text: "KIT ×× tool", "the KIT database", "What this page does.",
"Step one", "Step two", "What you get.")

See every component: \code{\link[=kit_gallery]{kit_gallery()}}.
}
\seealso{
Useful links:
\itemize{
  \item \url{https://github.com/jiewenTsai/kitDesign}
  \item \url{https://jiewentsai.github.io/kitDesign/}
  \item Report bugs at \url{https://github.com/jiewenTsai/kitDesign/issues}
}

}
\author{
\strong{Maintainer}: KIT Join Tool \email{joinkit@example.com}

Authors:
\itemize{
  \item KIT Join Tool \email{joinkit@example.com}
}

}
\keyword{internal}
