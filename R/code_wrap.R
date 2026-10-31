# 「用 R 怎麼做」的程式碼每行最多 70 欄
#
# 從 kitJoin 的 R/code_wrap.R 搬過來（演算法一模一樣；kitJoin 與 kitsUI 之後改用這一份）。
# 中日韓字算 2 欄。顯示之前才換行，產生程式碼的函式不用管寬度：
# - 註解：在空白或中文字之間換行，續行一樣以「# 」開頭；
# - 程式：在括號裡的逗號後面換行，續行對齊那個括號後面（R 在括號裡換行一定合法）；
# - 行尾註解讓這一行太寬時，搬到這一行上面。
# 換行後再 parse 一次，和原本的運算式不同（或原本就 parse 不了）時，那一段維持原樣。

KIT_CODE_WIDTH <- 70L

#' Display width of each line (CJK and full-width characters count as 2 columns)
#'
#' KIT code examples and notes are at most about 70 columns per line: Latin letters, digits, and
#' symbols count as 1 column, Chinese characters (and other full-width characters) count as 2.
#'
#' @param x A character vector (one element per line).
#' @return An integer vector: the number of columns in each line.
#' @seealso [kit_code_wrap()]
#' @examples
#' kit_code_cols(c("abc", "讀 CSV", ""))
#' # Which lines are wider than 70 columns
#' lines <- c("x <- 1", strrep("中", 36))
#' which(kit_code_cols(lines) > 70)
#' @export
kit_code_cols <- function(x) {
  vapply(x, function(s) {
    cp <- utf8ToInt(enc2utf8(s))
    if (length(cp) == 0 || anyNA(cp)) return(nchar(s, type = "width"))
    wide <- (cp >= 0x1100 & cp <= 0x115F) | (cp >= 0x2E80 & cp <= 0xA4CF) |
      (cp >= 0xAC00 & cp <= 0xD7A3) | (cp >= 0xF900 & cp <= 0xFAFF) |
      (cp >= 0xFE30 & cp <= 0xFE4F) | (cp >= 0xFF00 & cp <= 0xFF60) |
      (cp >= 0xFFE0 & cp <= 0xFFE6)
    as.integer(sum(ifelse(wide, 2L, 1L)))
  }, integer(1), USE.NAMES = FALSE)
}

#' Wrap code to at most 70 columns per line
#'
#' "How to do it in R" wraps the code only right before showing it ([kit_code()] does this
#' automatically), so functions that generate code need not worry about width:
#'
#' - Comments: break at spaces or between Chinese characters; continuation lines also start with
#'   "# "; punctuation is not put at the start of a line.
#' - Code: break after a comma inside parentheses, and align continuation lines just after that
#'   parenthesis (a line break inside parentheses is always valid R).
#'   If the parenthesis was opened on an earlier line (e.g. `mutate(` on its own line with the
#'   arguments on the next), continuation lines use the same indent as this line.
#' - If a trailing comment makes the line too wide, it is moved above the line.
#'
#' After wrapping, the code is parsed again: if the expression differs from the original (or the
#' original did not parse), the code is left unchanged.
#' Places that cannot be broken (e.g. a very long string) are also left as is and scroll sideways
#' in the code box.
#'
#' @param code The code (a string; may have several lines, or be several strings).
#' @param width Maximum columns per line.
#' @return A single string (returned as is when `code` has length 0).
#' @seealso [kit_code_cols()], [kit_code()]
#' @examples
#' code <- paste0(
#'   "x <- c(\"M03\", \"M03\", \"M03\", \"M36\", \"M36\", \"M36\", ",
#'   "\"M48\", \"M48\", \"M60\", \"M60\")"
#' )
#' cat(kit_code_wrap(code))
#' @export
kit_code_wrap <- function(code, width = KIT_CODE_WIDTH) {
  if (length(code) == 0) return(code)
  text <- paste(code, collapse = "\n")
  lines <- strsplit(text, "\n", fixed = TRUE)[[1]]
  if (all(kit_code_cols(lines) <= width)) return(text)
  # 每一行開始時，前面幾行還沒關上的括號有幾層
  depth <- integer(length(lines))
  for (i in seq_along(lines)[-1]) {
    depth[i] <- kit_scan_line(strsplit(lines[i - 1], "")[[1]], depth[i - 1])$depth
  }
  wrapped <- paste(unlist(Map(kit_wrap_line, lines, width, depth)), collapse = "\n")
  if (kit_code_same(text, wrapped)) wrapped else text
}

#' Whether the code is the same program before and after wrapping (same parsed expression); no
#' wrapping when the original does not parse
#' @noRd
kit_code_same <- function(a, b) {
  pa <- tryCatch(parse(text = a, keep.source = FALSE), error = function(e) NULL)
  pb <- tryCatch(parse(text = b, keep.source = FALSE), error = function(e) NULL)
  !is.null(pa) && !is.null(pb) && identical(lapply(pa, deparse), lapply(pb, deparse))
}

#' Scan one line: inside or outside strings, parentheses, where a comment starts, and where it can
#' break (", " inside parentheses)
#' depth: how many parentheses from earlier lines are still open when this line starts (recorded
#' as position 0 in the stack)
#' @noRd
kit_scan_line <- function(chars, depth = 0L) {
  quote <- ""; esc <- FALSE; stack <- rep(0L, depth); comment <- NA_integer_
  breaks <- integer(0); opens <- integer(0)
  for (i in seq_along(chars)) {
    ch <- chars[i]
    if (nzchar(quote)) {
      if (esc) esc <- FALSE else if (ch == "\\") esc <- TRUE else if (ch == quote) quote <- ""
      next
    }
    if (ch %in% c('"', "'", "`")) {
      quote <- ch
    } else if (ch == "#") {
      comment <- i
      break
    } else if (ch %in% c("(", "[", "{")) {
      stack <- c(stack, i)
    } else if (ch %in% c(")", "]", "}")) {
      stack <- utils::head(stack, -1)
    } else if (ch == "," && length(stack) > 0 && i < length(chars) && chars[i + 1] == " ") {
      breaks <- c(breaks, i)
      opens <- c(opens, stack[length(stack)])
    }
  }
  list(comment = comment, breaks = breaks, opens = opens, depth = length(stack))
}

#' Turn one comment line into several: break at spaces or between Chinese characters; punctuation
#' is not put at the start of a line
#' @noRd
kit_wrap_comment <- function(indent, text, width) {
  prefix <- paste0(indent, "# ")
  room <- width - kit_code_cols(prefix)
  if (room < 20) return(paste0(prefix, text))
  # 字詞：連續的英數符號一組，其他字一個字一組，空白一組
  tokens <- regmatches(text, gregexpr("[!-~]+| +|.", text, perl = TRUE))[[1]]
  # 原文：^[，。、：；）」』！？,.;:)]
  lead_punct <- "^[\uff0c\u3002\u3001\uff1a\uff1b\uff09\u300d\u300f\uff01\uff1f,.;:)]"
  out <- character(0); cur <- character(0)
  for (tk in tokens) {
    if (length(cur) == 0 && grepl("^ +$", tk)) next
    if (kit_code_cols(paste(c(cur, tk), collapse = "")) <= room || length(cur) == 0) {
      cur <- c(cur, tk)
    } else if (grepl(lead_punct, tk) && length(cur) > 1) {
      # 標點不放在行首：前一個字跟著標點一起換到下一行
      out <- c(out, sub(" +$", "", paste(utils::head(cur, -1), collapse = "")))
      cur <- c(cur[length(cur)], tk)
    } else if (grepl(lead_punct, tk)) {
      cur <- c(cur, tk)
    } else {
      out <- c(out, sub(" +$", "", paste(cur, collapse = "")))
      cur <- if (grepl("^ +$", tk)) character(0) else tk
    }
  }
  out <- c(out, sub(" +$", "", paste(cur, collapse = "")))
  paste0(prefix, out[nzchar(out)])
}

#' Turn one line into several
#' @noRd
kit_wrap_line <- function(line, width, depth = 0L) {
  if (kit_code_cols(line) <= width) return(line)
  indent <- sub("^( *).*$", "\\1", line)
  body <- substring(line, nchar(indent) + 1)
  if (startsWith(body, "#")) {
    return(kit_wrap_comment(indent, sub("^#+ ?", "", body), width))
  }
  chars <- strsplit(line, "")[[1]]
  scan <- kit_scan_line(chars, depth)
  if (!is.na(scan$comment)) {
    code <- sub(" +$", "", paste(chars[seq_len(scan$comment - 1)], collapse = ""))
    note <- sub("^#+ ?", "", paste(chars[scan$comment:length(chars)], collapse = ""))
    return(c(kit_wrap_comment(indent, note, width), kit_wrap_line(code, width, depth)))
  }
  if (length(scan$breaks) == 0) return(line)
  # 由左往右切：每段盡量長，但不超過 width；續行對齊括號後面
  pieces <- character(0); start <- 1L; lead <- ""
  starts <- integer(0); col_lead <- integer(0)
  # 第 pos 個字在輸出時的欄位：它所在那一段的縮排 + 那一段開頭到它前面的寬度
  out_col <- function(pos) {
    k <- max(which(starts <= pos))
    before <- if (pos > starts[k]) paste(chars[starts[k]:(pos - 1)], collapse = "") else ""
    col_lead[k] + kit_code_cols(before)
  }
  repeat {
    starts <- c(starts, start); col_lead <- c(col_lead, nchar(lead))
    rest <- paste0(lead, paste(chars[start:length(chars)], collapse = ""))
    if (kit_code_cols(rest) <= width) {
      pieces <- c(pieces, rest)
      break
    }
    ok <- which(scan$breaks >= start)
    if (length(ok) == 0) {
      pieces <- c(pieces, rest)
      break
    }
    fits <- ok[vapply(ok, function(j) {
      kit_code_cols(paste0(lead, paste(chars[start:scan$breaks[j]], collapse = ""))) <= width
    }, logical(1))]
    j <- if (length(fits) > 0) max(fits) else min(ok)
    cut <- scan$breaks[j]
    pieces <- c(pieces, paste0(lead, paste(chars[start:cut], collapse = "")))
    if (scan$opens[j] == 0L) {
      # 括號在前面幾行打開的：續行和這一行一樣縮排
      lead <- indent
    } else {
      open_col <- out_col(scan$opens[j]) + 1L
      lead <- if (open_col <= width - 30L) strrep(" ", open_col) else paste0(indent, "    ")
    }
    start <- cut + 2L
  }
  pieces
}
