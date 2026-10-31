% English translation of man/kit_files.Rd (roxygen2 output of R/files.R). Update by hand when the Chinese changes.
\name{kit_files}
\alias{kit_files}
\alias{kit_fix_utf8_chr}
\alias{kit_fix_utf8_df}
\alias{kit_is_valid_utf8_df}
\alias{kit_sav_safe_names}
\alias{kit_truncate_bytes}
\alias{kit_gz_path}
\alias{kit_open_browser}
\title{File helpers: encoding, SPSS variable names, compressed file paths, opening the browser}
\usage{
kit_fix_utf8_chr(x)

kit_fix_utf8_df(df)

kit_is_valid_utf8_df(df)

kit_sav_safe_names(cols)

kit_truncate_bytes(x, max_bytes)

kit_gz_path(path)

kit_open_browser(url)
}
\arguments{
\item{x}{A character vector (\code{kit_fix_utf8_chr()}) or a single string (\code{kit_truncate_bytes()}).}

\item{df}{A data frame.}

\item{cols}{Column names.}

\item{max_bytes}{Maximum number of bytes.}

\item{path}{A file path.}

\item{url}{A URL.}
}
\value{
An object of the same kind as the input; \code{kit_is_valid_utf8_df()} gives \code{TRUE} / \code{FALSE}; \code{kit_open_browser()} gives \code{NULL}.
}
\description{
\itemize{
\item \code{kit_fix_utf8_chr()}: converts text to UTF-8 (characters that cannot be converted become \verb{?}); returns non-text input as is.
\item \code{kit_fix_utf8_df()}: converts every text column (and factor) of a data frame to UTF-8, keeping SAV variable labels and value labels.
\item \code{kit_is_valid_utf8_df()}: whether the column names and text columns are all valid UTF-8.
\item \code{kit_sav_safe_names()}: converts to valid SPSS variable names (tested against \code{haven::write_sav()}: only letters,
digits, and \verb{_ . @ # $}; starts with a letter or \code{@}; does not end with \code{.}; not a reserved word; at most 64 bytes;
unique ignoring case, with \verb{_2}, \verb{_3} added from the second duplicate on).
\item \code{kit_truncate_bytes()}: truncates by UTF-8 byte count without cutting a Chinese character in half.
\item \code{kit_gz_path()}: readr decides whether to decompress from the extension; if the path does not end in \code{.gz}, it copies the file to a temp file ending in \code{.gz}.
\item \code{kit_open_browser()}: opens the URL in the default browser (on Windows, unaffected by the RStudio viewer).
}
}
\examples{
kit_sav_safe_names(c("1st wave", "AND", "id", "ID"))
kit_truncate_bytes(strrep("測", 30), 64)
}
