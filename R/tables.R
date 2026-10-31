# 資料表（DataTable）與數字格式

# 預覽表最多顯示幾欄、幾列
KIT_PREVIEW_COLS <- 20L
KIT_PREVIEW_ROWS <- 10L

#' 整數加千分位
#'
#' KIT 設計語言：四位數以上加千分位，「3,389 人」。小數會四捨五入成整數。
#'
#' @param x 數字（或可以轉成數字的字串）。
#' @return 字串，例如 `"3,418"`。
#' @examples
#' kit_num(3418)
#' kit_num(c(5, 12345, 1e6))
#' @export
kit_num <- function(x) {
  formatC(as.numeric(x), format = "d", big.mark = ",")
}

#' 維度描述：「5 列 × 7 欄」
#'
#' @param nrow,ncol 列數、欄數。
#' @param preview_cols 畫面上只預覽前幾欄時給它（比欄數少時補一句「以下只預覽前 N 欄」）。
#' @return 字串。
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

#' 長表的說明：「共 3,418 列 × 25 欄，以下前 10 列、前 20 欄。」
#'
#' 放在表上面的一行 `kit-hint` 小字。
#'
#' @param nrow,ncol 全部的列數、欄數（`ncol = NULL` 時不提欄）。
#' @param shown_rows,shown_cols 畫面上顯示幾列、幾欄（`shown_cols = NULL` 時不提欄）。
#' @return 字串。
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

#' 預覽用：每一欄轉成方便閱讀的文字
#'
#' 有值標籤的欄（SPSS 檔讀進來的 haven_labelled）顯示「`[值] 標籤`」；
#' 日期顯示 yyyy-mm-dd；數字最多 4 位小數。
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

#' 小表格（直接放在 renderUI() 裡，不用另開 output）
#'
#' 白底、黑表頭白字、斑馬紋、寬度跟著內容。整數欄自動加千分位（3389 → 3,389）。
#' 上面放一個 `h4` 標題與一行 [kit_rows_note()]。
#'
#' @param df data.frame。
#' @param class 表格的 class。
#' @return `<table class="table table-sm table-striped">`。
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

#' 預覽表的資料（交給 `shiny::renderTable()`）
#'
#' 欄位太多時只取前 `max_cols` 欄（優先保留 `priority_cols`），列只取前 `n` 列，
#' 每一欄轉成方便閱讀的文字（值標籤寫成「`[值] 標籤`」、日期 yyyy-mm-dd）。
#' 上面配一行 [kit_rows_note()]。
#'
#' @param df data.frame。
#' @param priority_cols 一定要放進預覽的欄（例如 ID 欄），排在最前面。
#' @param n 最多幾列。
#' @param max_cols 最多幾欄。
#' @return data.frame（全部是文字欄）。
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

#' 寬的表放在這裡面：在自己的框裡左右捲，不撐破版面
#'
#' @param ... 表格（例如 [kit_static_table()] 或 `shiny::tableOutput()`）。
#' @param tall 長表時固定高度（約 26rem）、表頭固定在上面。
#' @return `<div class="kit-table-scroll">`。
#' @examples
#' kit_table_scroll(kit_static_table(data.frame(id = 1:3)))
#' @export
kit_table_scroll <- function(..., tall = FALSE) {
  shiny::tags$div(class = paste(c("kit-table-scroll", if (tall) "kit-table-tall"), collapse = " "), ...)
}

#' 圖的類別色（Chart）
#'
#' 色盲友善的 Okabe–Ito，世代、量尺、分數依序取色：藍、橘、綠、紫紅、天藍、朱紅；
#' 超過 6 類從頭再取。參考線、帶子、沒有判斷的點用 [kit_chart_neutral()]。
#'
#' @param n `NULL` 時回傳全部 6 個（具名）；給數字時依序取 `n` 個（不具名）。
#' @return 顏色字串向量。
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

#' 圖裡不分類別的中性色
#'
#' 參考線、帶子、沒有判斷的點。
#'
#' @return `"#7F7F7F"`。
#' @examples
#' kit_chart_neutral()
#' @export
kit_chart_neutral <- function() "#7F7F7F"
