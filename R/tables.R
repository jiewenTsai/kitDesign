# 資料表（DataTable）與數字格式

# 預覽表最多顯示幾欄、幾列
KIT_PREVIEW_COLS <- 20L
KIT_PREVIEW_ROWS <- 10L

#' Integer with thousands separators
#'
#' KIT design language: numbers with four or more digits get thousands separators, as in
#' "3,389 人" ("3,389 people"). Decimals are rounded to integers.
#'
#' @param x A number (or a string that can be converted to a number).
#' @return A string, for example `"3,418"`.
#' @examples
#' kit_num(3418)
#' kit_num(c(5, 12345, 1e6))
#' @export
kit_num <- function(x) {
  formatC(as.numeric(x), format = "d", big.mark = ",")
}

#' Dimension text: "5 列 × 7 欄" ("5 rows × 7 columns")
#'
#' @param nrow,ncol Number of rows and columns.
#' @param preview_cols Give this when the screen previews only the first few columns (if fewer
#'   than the column count, adds "以下只預覽前 N 欄" ("previewing only the first N columns below")).
#' @return A string.
#' @examples
#' kit_dims(3418, 25)
#' kit_dims(3418, 25, preview_cols = 20)
#' @export
kit_dims <- function(nrow, ncol, preview_cols = NULL) {
  # 原文： 列 ×  |  欄
  base <- paste0(kit_num(nrow), " \u5217 \u00d7 ", kit_num(ncol), " \u6b04")
  if (!is.null(preview_cols) && preview_cols < ncol) {
    # 原文：（以下只預覽前  |  欄）
    paste0(base, "\uff08\u4ee5\u4e0b\u53ea\u9810\u89bd\u524d ", preview_cols, " \u6b04\uff09")
  } else {
    base
  }
}

#' Note for a long table: "共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。" ("3,418 rows × 25 columns
#' in total; first 10 rows and 20 columns below.")
#'
#' One line of small `kit-hint` text placed above the table.
#'
#' @param nrow,ncol Total number of rows and columns (with `ncol = NULL`, columns are not
#'   mentioned).
#' @param shown_rows,shown_cols How many rows and columns are shown on screen (with
#'   `shown_cols = NULL`, columns are not mentioned).
#' @return A string.
#' @examples
#' kit_rows_note(157, shown_rows = 20)
#' kit_rows_note(3418, 25, shown_rows = 10, shown_cols = 20)
#' kit_rows_note(8, shown_rows = 10)
#' @export
kit_rows_note <- function(nrow, ncol = NULL, shown_rows, shown_cols = NULL) {
  # 原文： 列
  total <- if (is.null(ncol)) paste0(kit_num(nrow), " \u5217") else kit_dims(nrow, ncol)
  cut_rows <- nrow > shown_rows
  cut_cols <- !is.null(ncol) && !is.null(shown_cols) && ncol > shown_cols
  # 原文：共  | ，以下是全部。
  if (!cut_rows && !cut_cols) return(paste0("\u5171 ", total, "\uff0c\u4ee5\u4e0b\u662f\u5168\u90e8\u3002"))
  # 原文：前  |  列 | 全部的列
  rows <- if (cut_rows) paste0("\u524d ", kit_num(shown_rows), " \u5217") else "\u5168\u90e8\u7684\u5217"
  # 原文：、前  |  欄
  cols <- if (cut_cols) paste0("\u3001\u524d ", kit_num(shown_cols), " \u6b04")
  # 原文：共  | ，以下 | 。
  paste0("\u5171 ", total, "\uff0c\u4ee5\u4e0b", rows, cols, "\u3002")
}

#' For previews: convert each column to easy-to-read text
#'
#' Columns with value labels (haven_labelled, read from SPSS files) show "`[value] label`";
#' dates show as yyyy-mm-dd; numbers have at most 4 decimal places.
#' @noRd
kit_display_df <- function(df, n = NULL) {
  df <- as.data.frame(df, stringsAsFactors = FALSE, check.names = FALSE)
  # 先取前 n 列再轉：值標籤要自己帶著（沒有載入 haven 時，`[` 會把它丟掉）
  rows <- seq_len(if (is.null(n)) nrow(df) else min(n, nrow(df)))
  out <- lapply(df, function(x) {
    labels <- attr(x, "labels", exact = TRUE)
    labelled <- inherits(x, "haven_labelled")
    if (labelled) x <- as.vector(unclass(x))
    x <- x[rows]
    if (length(labels) > 0 && labelled) {
      v <- x
      hit <- match(v, unname(labels))
      shown <- ifelse(is.na(hit), as.character(v), paste0("[", v, "] ", names(labels)[hit]))
      shown[is.na(v)] <- NA_character_
      return(shown)
    }
    if (inherits(x, c("Date", "POSIXt", "hms"))) return(format(x))
    if (is.numeric(x)) return(as.character(round(x, 4)))
    as.character(x)
  })
  as.data.frame(out, stringsAsFactors = FALSE, check.names = FALSE, optional = TRUE)
}

#' Small table (put directly inside renderUI(); no separate output needed)
#'
#' White background, black header with white text, zebra stripes, width fits the content. Integer
#' columns get thousands separators automatically (3389 → 3,389).
#' Put an `h4` title and a [kit_rows_note()] line above it.
#'
#' @param df A data.frame.
#' @param class The table's class.
#' @return `<table class="table table-sm table-striped">`.
#' @examples
#' kit_static_table(data.frame(世代 = c("M03", "M36"), 人數 = c(3389, 1250)))
#' @export
kit_static_table <- function(df, class = "table table-sm table-striped") {
  df <- as.data.frame(df, stringsAsFactors = FALSE, check.names = FALSE)
  for (j in seq_along(df)) {
    x <- df[[j]]
    if (is.numeric(x) && !inherits(x, "haven_labelled") && all(is.na(x) | x == round(x))) {
      df[[j]] <- ifelse(is.na(x), NA_character_, kit_num(x))
    }
  }
  cells <- kit_display_df(df)
  shiny::tags$table(
    class = class,
    shiny::tags$thead(shiny::tags$tr(lapply(names(cells), shiny::tags$th))),
    shiny::tags$tbody(lapply(seq_len(nrow(cells)), function(i) {
      shiny::tags$tr(lapply(cells[i, , drop = TRUE], function(v) {
        shiny::tags$td(if (is.na(v)) "" else v)
      }))
    }))
  )
}

#' Data for a preview table (pass to `shiny::renderTable()`)
#'
#' With too many columns, only the first `max_cols` columns are kept (`priority_cols` are kept
#' first); only the first `n` rows are kept.
#' Each column is converted to easy-to-read text (value labels as "`[value] label`", dates as
#' yyyy-mm-dd). Put a [kit_rows_note()] line above it.
#'
#' @param df A data.frame.
#' @param priority_cols Columns that must be in the preview (for example the ID column); they go
#'   first.
#' @param n Maximum number of rows.
#' @param max_cols Maximum number of columns.
#' @return A data.frame (all columns are text).
#' @examples
#' df <- as.data.frame(matrix(1:60, nrow = 2))
#' dim(kit_preview_table(df, priority_cols = "V30", n = 1))
#' @export
kit_preview_table <- function(df, priority_cols = NULL, n = KIT_PREVIEW_ROWS,
                              max_cols = KIT_PREVIEW_COLS) {
  df <- as.data.frame(df, stringsAsFactors = FALSE, check.names = FALSE)
  cols <- names(df)
  if (length(cols) > max_cols) {
    priority_cols <- intersect(priority_cols, cols)
    keep <- unique(c(priority_cols, setdiff(cols, priority_cols)))
    df <- df[, keep[seq_len(max_cols)], drop = FALSE]
  }
  kit_display_df(df, n)
}

#' Put wide tables in here: they scroll sideways in their own box and do not break the layout
#'
#' @param ... Tables (for example [kit_static_table()] or `shiny::tableOutput()`).
#' @param tall For long tables: fixed height (about 26rem), with the header fixed at the top.
#' @return `<div class="kit-table-scroll">`.
#' @examples
#' kit_table_scroll(kit_static_table(data.frame(id = 1:3)))
#' @export
kit_table_scroll <- function(..., tall = FALSE) {
  shiny::tags$div(class = paste(c("kit-table-scroll", if (tall) "kit-table-tall"), collapse = " "), ...)
}

#' Categorical chart colors
#'
#' Colorblind-friendly Okabe–Ito. Cohorts, scales, and scores take colors in order: blue, orange,
#' green, reddish purple, sky blue, vermillion; past 6 categories it starts over. For reference
#' lines, bands, and points with no judgment, use [kit_chart_neutral()].
#'
#' @param n When `NULL`, returns all 6 (named); when a number, takes the first `n` in order
#'   (unnamed).
#' @return A character vector of colors.
#' @examples
#' kit_chart_colors()
#' kit_chart_colors(3)
#' @export
kit_chart_colors <- function(n = NULL) {
  cols <- c(
    blue = "#0072B2", orange = "#E69F00", green = "#009E73", purple = "#CC79A7",
    sky = "#56B4E9", vermillion = "#D55E00"
  )
  if (is.null(n)) return(cols)
  unname(rep_len(cols, n))
}

#' Neutral color for non-categorical chart elements
#'
#' Reference lines, bands, and points with no judgment.
#'
#' @return `"#7F7F7F"`.
#' @examples
#' kit_chart_neutral()
#' @export
kit_chart_neutral <- function() "#7F7F7F"
