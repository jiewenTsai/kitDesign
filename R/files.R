# 讀寫檔案的小工具：kitJoin 與 kitsUI 原本各有一份一模一樣的

#' File helpers: encoding, SPSS variable names, compressed file paths, opening the browser
#'
#' - `kit_fix_utf8_chr()`: converts text to UTF-8 (characters that cannot be converted become `?`);
#'   returns non-text input as is.
#' - `kit_fix_utf8_df()`: converts every text column (and factor) of a data frame to UTF-8, keeping
#'   SAV variable labels and value labels.
#' - `kit_is_valid_utf8_df()`: whether the column names and text columns are all valid UTF-8.
#' - `kit_sav_safe_names()`: converts to valid SPSS variable names (tested against
#'   `haven::write_sav()`: only letters, digits, and `_ . @ # $`; starts with a letter or `@`; does
#'   not end with `.`; not a reserved word; at most 64 bytes; unique ignoring case, with `_2`, `_3`
#'   added from the second duplicate on).
#' - `kit_truncate_bytes()`: truncates by UTF-8 byte count without cutting a Chinese character in
#'   half.
#' - `kit_gz_path()`: readr decides whether to decompress from the extension; if the path does not end
#'   in `.gz`, it copies the file to a temp file ending in `.gz`.
#' - `kit_open_browser()`: opens the URL in the default browser (on Windows, unaffected by the
#'   RStudio viewer).
#'
#' @param x A character vector (`kit_fix_utf8_chr()`) or a single string (`kit_truncate_bytes()`).
#' @param df A data frame.
#' @param cols Column names.
#' @param max_bytes Maximum number of bytes.
#' @param path A file path.
#' @param url A URL.
#' @return An object of the same kind as the input; `kit_is_valid_utf8_df()` gives `TRUE` / `FALSE`;
#'   `kit_open_browser()` gives `NULL`.
#' @examples
#' kit_sav_safe_names(c("1st wave", "AND", "id", "ID"))
#' kit_truncate_bytes(strrep("測", 30), 64)
#' @name kit_files
NULL

#' @rdname kit_files
#' @export
kit_fix_utf8_chr <- function(x) {
  if (!is.character(x)) return(x)
  iconv(x, from = "", to = "UTF-8", sub = "?")
}

#' @rdname kit_files
#' @export
kit_fix_utf8_df <- function(df) {
  df[] <- lapply(df, function(x) {
    if (is.factor(x)) {
      label <- attr(x, "label", exact = TRUE)
      x <- kit_fix_utf8_chr(as.character(x))
      attr(x, "label") <- label
      return(x)
    }
    if (!is.character(x)) return(x)
    # iconv() 會清掉屬性（含 haven 的 class 與標籤），轉完再放回去
    attrs <- attributes(x)
    x <- kit_fix_utf8_chr(as.vector(unclass(x)))
    attributes(x) <- attrs
    x
  })
  df
}

#' @rdname kit_files
#' @export
kit_is_valid_utf8_df <- function(df) {
  chr_ok <- vapply(df, function(x) {
    !is.character(x) || all(validUTF8(x[!is.na(x)]))
  }, logical(1))
  all(validUTF8(names(df))) && all(chr_ok)
}

# SPSS 的保留字：不能當變項名稱
KIT_SPSS_RESERVED <- c(
  "ALL", "AND", "BY", "EQ", "GE", "GT", "LE", "LT", "NE", "NOT", "OR", "TO",
  "WITH"
)

#' @rdname kit_files
#' @export
kit_sav_safe_names <- function(cols) {
  out <- gsub("[^[:alnum:]_.@#$]", "_", cols)
  out <- sub("\\.+$", "", out)
  needs_prefix <- !grepl("^[[:alpha:]@]", out)
  out[needs_prefix] <- paste0("v_", out[needs_prefix])
  reserved <- toupper(out) %in% KIT_SPSS_RESERVED
  out[reserved] <- paste0(out[reserved], "_")
  out <- vapply(out, kit_truncate_bytes, character(1), max_bytes = 64L, USE.NAMES = FALSE)
  # 不分大小寫的重複：第二個起加上 _2、_3…
  for (i in seq_along(out)) {
    taken <- toupper(out[seq_len(i - 1)])
    if (!toupper(out[i]) %in% taken) next
    k <- 2L
    repeat {
      tail <- paste0("_", k)
      candidate <- paste0(kit_truncate_bytes(out[i], 64L - nchar(tail, "bytes")), tail)
      if (!toupper(candidate) %in% c(taken, toupper(out[-seq_len(i)]))) break
      k <- k + 1L
    }
    out[i] <- candidate
  }
  out
}

#' @rdname kit_files
#' @export
kit_truncate_bytes <- function(x, max_bytes) {
  while (nchar(x, "bytes") > max_bytes) x <- substr(x, 1, nchar(x) - 1)
  x
}

#' @rdname kit_files
#' @export
kit_gz_path <- function(path) {
  if (grepl("[.]gz$", path)) return(path)
  out <- tempfile(fileext = ".csv.gz")
  file.copy(path, out)
  out
}

#' @rdname kit_files
#' @export
kit_open_browser <- function(url) {
  if (.Platform$OS.type == "windows") {
    utils::browseURL(url, browser = NULL)
  } else {
    utils::browseURL(url)
  }
  invisible(NULL)
}
