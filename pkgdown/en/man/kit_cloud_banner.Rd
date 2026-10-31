% English translation of man/kit_cloud_banner.Rd (roxygen2 output of R/cloud.R). Update by hand when the Chinese changes.
\name{kit_cloud_banner}
\alias{kit_cloud_banner}
\title{Cloud version reminder banner (one line below the header)}
\usage{
kit_cloud_banner(...)
}
\arguments{
\item{...}{The banner content.}
}
\value{
\verb{<div class="alert alert-warning kit-cloud-banner" role="alert">}.
}
\description{
A yellow line reminding users that their data go to the cloud. The app writes the text itself
(each app's server location and usage notes differ).
}
\examples{
kit_cloud_banner("此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。")
# "This is the cloud version: uploaded data are sent to a cloud server. For data with personal information, use the local version."
}
