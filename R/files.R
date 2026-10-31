# 讀寫檔案的小工具：kitJoin 與 kitsUI 原本各有一份一模一樣的

#' 檔案的小工具：編碼、SPSS 變項名稱、壓縮檔路徑、開啟瀏覽器
#'
#' - `kit_fix_utf8_chr()`：文字轉成 UTF-8（轉不了的字換成 `?`）；不是文字時原樣傳回。
#' - `kit_fix_utf8_df()`：資料框每個文字欄（與因子）轉成 UTF-8，保留 SAV 的變項標籤與數值標籤。
#' - `kit_is_valid_utf8_df()`：欄名與文字欄是不是都是合法的 UTF-8。
#' - `kit_sav_safe_names()`：轉成合法的 SPSS 變項名稱（以 `haven::write_sav()` 實測：只能有字母、
#'   數字與 `_ . @ # $`；開頭是字母或 `@`；不以 `.` 結尾；不是保留字；最長 64 bytes；
#'   不分大小寫不重複，重複的第二個起加 `_2`、`_3`）。
#' - `kit_truncate_bytes()`：依 UTF-8 位元組數截斷，不切斷中文字。
#' - `kit_gz_path()`：readr 看副檔名決定要不要解壓縮；路徑不是 `.gz` 結尾時，複製成 `.gz` 結尾的暫存檔。
#' - `kit_open_browser()`：在預設瀏覽器開啟網址（Windows 上不受 RStudio 檢視器影響）。
#'
#' @param x 文字向量（`kit_fix_utf8_chr()`）或一個字串（`kit_truncate_bytes()`）。
#' @param df 資料框。
#' @param cols 欄名。
#' @param max_bytes 最多幾個位元組。
#' @param path 檔案路徑。
#' @param url 網址。
#' @return 和輸入同類的物件；`kit_is_valid_utf8_df()` 是 `TRUE`／`FALSE`；`kit_open_browser()` 是 `NULL`。
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
