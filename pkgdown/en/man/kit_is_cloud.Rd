% English translation of man/kit_is_cloud.Rd (roxygen2 output of R/cloud.R). Update by hand when the Chinese changes.
\name{kit_is_cloud}
\alias{kit_is_cloud}
\title{Is this the cloud version?}
\usage{
kit_is_cloud()
}
\value{
\code{TRUE} or \code{FALSE}.
}
\description{
Checks the environment variable \code{KIT_DEPLOY} first (\code{"cloud"} or \code{"local"}, set in Connect Cloud);
if it is not set, Posit Connect's default \code{R_CONFIG_ACTIVE = "rsconnect"} counts as the cloud version.
}
\examples{
kit_is_cloud()
}
\seealso{
\code{\link[=kit_cloud_banner]{kit_cloud_banner()}}, \code{\link[=kit_cloud_footer]{kit_cloud_footer()}}
}
