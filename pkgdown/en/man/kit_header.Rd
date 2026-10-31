% English translation of man/kit_header.Rd (roxygen2 output of R/setup.R). Update by hand when the Chinese changes.
\name{kit_header}
\alias{kit_header}
\title{KIT header}
\usage{
kit_header(
  title,
  subtitle = NULL,
  tagline = NULL,
  version = NULL,
  date = NULL,
  meta_extra = NULL,
  logo = TRUE,
  show_kitdesign = FALSE,
  brand = kit_current_brand()
)
}
\arguments{
\item{title}{The tool name (the header h1, also the browser tab title), e.g. "KIT 資料串接工具" ("KIT data join tool").}

\item{subtitle}{The subtitle (bold), e.g. the database name "臺灣幼兒發展調查資料庫" (the KIT database).}

\item{tagline}{A phrase after the subtitle (e.g. "跨波次資料處理", "cross-wave data processing"); \code{NULL} shows nothing.}

\item{version, date}{Version and date for the header's version line, usually read from the app's own DESCRIPTION:
\code{kit_app_description("kitJoin")}.}

\item{meta_extra}{Text appended to the version line (e.g. "kits 0.25.0").}

\item{logo}{Whether the header shows the brand logo (KIT's is the bean plus the KIT wordmark): \code{TRUE} (the logo file is served by an
htmlDependency; for use in Shiny), \code{"inline"} (the logo is written into the page, for a standalone
HTML file without Shiny, such as a user manual), or \code{FALSE}.}

\item{show_kitdesign}{Whether to append the kitDesign version to the version line ("kitDesign 0.1.0"),
so both versions are visible when reporting a problem.}

\item{brand}{The brand: logo, tab icon, colors (\code{\link[=kit_brand]{kit_brand()}}). Defaults to \code{\link[=kit_current_brand]{kit_current_brand()}}:
KIT when \code{options(kitDesign.brand = )} is not set.}
}
\value{
\verb{<div class="kit-header mb-4">}.
}
\description{
A lime color block, black border, header shadow; the full logo on the left, and on the right the tool name, one subtitle line, and one version line.
One per app, at the very top (\code{\link[=kit_page]{kit_page()}} already places it). It also sets the browser tab
icon (the bean logo for KIT).
}
\details{
Logo, tab icon, and colors come from the brand (\code{\link[=kit_brand]{kit_brand()}}). When the brand's colors differ from KIT's, the header adds a short
\verb{<style>} that overrides the differing \verb{--nb-*} variables; for the KIT brand nothing is added and the page is the same as before.
}
\examples{
kit_header("KIT 資料串接工具", "臺灣幼兒發展調查資料庫", tagline = "跨波次資料處理",
           version = "0.5.0", date = "2026-10-31")
}
