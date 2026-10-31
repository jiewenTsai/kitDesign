# 「用 R 怎麼做」的程式碼每行最多 70 欄
#
# 從 kitJoin 的 R/code_wrap.R 搬過來（演算法一模一樣；kitJoin 與 kitsUI 之後改用這一份）。
# 中日韓字算 2 欄。顯示之前才換行，產生程式碼的函式不用管寬度：
# - 註解：在空白或中文字之間換行，續行一樣以「# 」開頭；
# - 程式：在括號裡的逗號後面換行，續行對齊那個括號後面（R 在括號裡換行一定合法）；
# - 行尾註解讓這一行太寬時，搬到這一行上面。
# 換行後再 parse 一次，和原本的運算式不同（或原本就 parse 不了）時，那一段維持原樣。

KIT_CODE_WIDTH <- 70L

#' 每行的顯示寬度（中日韓字、全形字算 2 欄）
#'
#' KIT 的程式碼範例與說明一行最多約 70 欄：英文字母、數字、符號算 1 欄，
#' 中文字（與其他全形字）算 2 欄。
#'
#' @param x 字串向量（一個元素一行）。
#' @return 整數向量：每一行幾欄。
#' @seealso [kit_code_wrap()]
#' @examples
#' kit_code_cols(c("abc", "讀 CSV", ""))
#' # 哪幾行超過 70 欄
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

#' 把一段程式碼換行成每行最多 70 欄
#'
#' 「用 R 怎麼做」顯示之前才換行（[kit_code()] 會自動做），產生程式碼的函式不用管寬度：
#'
#' - 註解：在空白或中文字之間換行，續行一樣以「# 」開頭；標點不放在行首。
#' - 程式：在括號裡的逗號後面換行，續行對齊那個括號後面（R 在括號裡換行一定合法）。
#' - 行尾註解讓這一行太寬時，搬到這一行上面。
#'
#' 換行後再 parse 一次：和原本的運算式不同（或原本就 parse 不了）時，維持原樣。
#' 斷不開的地方（例如很長的字串）也維持原樣，在程式碼框裡左右捲。
#'
#' @param code 程式碼（字串；可以有好幾行，或好幾個字串）。
#' @param width 一行最多幾欄。
#' @return 一個字串（`code` 長度 0 時原樣傳回）。
#' @seealso [kit_code_cols()]、[kit_code()]
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
  wrapped <- paste(unlist(lapply(lines, kit_wrap_line, width = width)), collapse = "\n")
  if (kit_code_same(text, wrapped)) wrapped else text
}

#' 換行前後是不是同一段程式（parse 後的運算式相同）；原本 parse 不了時不換
#' @noRd
kit_code_same <- function(a, b) {
  pa <- tryCatch(parse(text = a, keep.source = FALSE), error = function(e) NULL)
  pb <- tryCatch(parse(text = b, keep.source = FALSE), error = function(e) NULL)
  !is.null(pa) && !is.null(pb) && identical(lapply(pa, deparse), lapply(pb, deparse))
}

#' 掃一行：字串裡外、括號、註解從哪裡開始、可以換行的地方（括號裡的「, 」）
#' @noRd
kit_scan_line <- function(chars) {
  quote <- ""; esc <- FALSE; stack <- integer(0); comment <- NA_integer_
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
  list(comment = comment, breaks = breaks, opens = opens)
}

#' 一行註解換成好幾行：在空白或中文字之間斷開；標點不放在行首
#' @noRd
kit_wrap_comment <- function(indent, text, width) {
  prefix <- paste0(indent, "# ")
  room <- width - kit_code_cols(prefix)
  if (room < 20) return(paste0(prefix, text))
  # 字詞：連續的英數符號一組，其他字一個字一組，空白一組
  tokens <- regmatches(text, gregexpr("[!-~]+| +|.", text, perl = TRUE))[[1]]
  # 原文：^[，。、：；）」』！？,.;:)]
  lead_punct <- "^[\uff0c\u3002\u3001\uff1a\uff1b\uff09\u300d\u300f\uff01\uff1f,.;:)]"
  out <- character(0); cur <- ""
  for (tk in tokens) {
    if (!nzchar(cur) && grepl("^ +$", tk)) next
    cand <- paste0(cur, tk)
    if (kit_code_cols(cand) <= room || !nzchar(cur) || grepl(lead_punct, tk)) {
      cur <- cand
    } else {
      out <- c(out, sub(" +$", "", cur))
      cur <- if (grepl("^ +$", tk)) "" else tk
    }
  }
  out <- c(out, sub(" +$", "", cur))
  paste0(prefix, out[nzchar(out)])
}

#' 一行換成好幾行
#' @noRd
kit_wrap_line <- function(line, width) {
  if (kit_code_cols(line) <= width) return(line)
  indent <- sub("^( *).*$", "\\1", line)
  body <- substring(line, nchar(indent) + 1)
  if (startsWith(body, "#")) {
    return(kit_wrap_comment(indent, sub("^#+ ?", "", body), width))
  }
  chars <- strsplit(line, "")[[1]]
  scan <- kit_scan_line(chars)
  if (!is.na(scan$comment)) {
    code <- sub(" +$", "", paste(chars[seq_len(scan$comment - 1)], collapse = ""))
    note <- sub("^#+ ?", "", paste(chars[scan$comment:length(chars)], collapse = ""))
    return(c(kit_wrap_comment(indent, note, width), kit_wrap_line(code, width)))
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
    open_col <- out_col(scan$opens[j]) + 1L
    lead <- if (open_col <= width - 30L) strrep(" ", open_col) else paste0(indent, "    ")
    start <- cut + 2L
  }
  pieces
}
