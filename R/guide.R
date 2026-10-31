# 頁面說明（這一頁做什麼）與圖解

#' Page guide: what this page does
#'
#' A one-line guide at the top of each tab, collapsed by default: only the sentence "這一頁做什麼："
#' ("What this page does:") is visible, with "看步驟 ▸" ("See steps ▸") next to it; opening it
#' shows the steps, what you get, additional notes, and technical notes. No border, small gray
#' text, a light line below.
#'
#' @param goal One sentence, no more than 30 characters.
#' @param steps The steps to follow: [kit_steps()] (3–6 points), or a character vector (turned
#'   into [kit_steps()] automatically).
#' @param output What you get.
#' @param technical Technical notes (for people who want to know how it works; collapsed one more
#'   level); `NULL` shows nothing.
#' @param note Additional notes (small gray text); `NULL` shows nothing.
#' @param diagram A diagram ([kit_diagram()]): placed outside the guide box, right after it, and
#'   visible even when the guide is collapsed; `NULL` shows nothing.
#' @return Without a diagram, `<details class="kit-guide kit-guide-page">`; with a diagram, it is
#'   wrapped in `<div class="kit-guide kit-guide-wrap">`.
#' @seealso [kit_steps()], [kit_diagram()]
#' @examples
#' kit_tab_guide(
#'   goal = "把多個波次的檔案依 ID 接成一張寬資料。",
#'   steps = kit_steps("選要串接的檔案", "選 ID 欄", "按「執行串接」"),
#'   output = "一張寬資料，可以下載 CSV、SAV。"
#' )
#' @export
kit_tab_guide <- function(goal, steps, output, technical = NULL, note = NULL, diagram = NULL) {
  # kitsUI 的 mod_guide() 直接收字串向量
  if (is.character(steps)) steps <- kit_steps(steps)
  guide <- shiny::tags$details(
    class = if (is.null(diagram)) "kit-guide kit-guide-page" else "kit-guide-page",
    shiny::tags$summary(
      # 原文：這一頁做什麼：
      shiny::tags$strong("\u9019\u4e00\u9801\u505a\u4ec0\u9ebc\uff1a"), goal,
      shiny::tags$span(class = "kit-guide-more")
    ),
    shiny::tags$div(
      class = "kit-guide-body",
      # 原文：步驟：
      shiny::tags$div(shiny::tags$strong("\u6b65\u9a5f\uff1a"), steps),
      # 原文：會得到：
      shiny::tags$p(shiny::tags$strong("\u6703\u5f97\u5230\uff1a"), output),
      if (!is.null(note)) shiny::tags$p(class = "kit-guide-note", note),
      if (!is.null(technical)) {
        shiny::tags$details(
          # 原文：技術說明（給想了解原理的人）
          shiny::tags$summary("\u6280\u8853\u8aaa\u660e\uff08\u7d66\u60f3\u4e86\u89e3\u539f\u7406\u7684\u4eba\uff09"),
          shiny::tags$p(technical)
        )
      }
    )
  )
  if (is.null(diagram)) return(guide)
  # 有圖解時：外層一個 .kit-guide（下緣的淡線），裡面是收合的說明，接著圖解
  shiny::tags$div(class = "kit-guide kit-guide-wrap", guide, diagram)
}

#' Numbered list of steps (for the `steps` of [kit_tab_guide()])
#'
#' Note: this is the `<ol>` inside the guide box, not a step card; step cards are
#' [kit_step_card()].
#'
#' @param ... One string (or character vector) per step.
#' @return `<ol class="kit-steps">`.
#' @examples
#' kit_steps("選檔案", "選 ID 欄", "按「執行串接」")
#' @export
kit_steps <- function(...) {
  shiny::tags$ol(class = "kit-steps", lapply(c(...), shiny::tags$li))
}

#' Small table for diagrams (2–3 columns, 2–4 rows)
#'
#' A supporting element: no box, table as wide as its content, 1px thin lines, a light header (not
#' the black header of large data tables); values in a monospace font. New columns get a light
#' lime background and "（新）" ("(new)") after the name, so it does not rely on color alone;
#' empty cells show a gray "（空）" ("(empty)").
#'
#' @param df A data.frame (values are converted to text); `NA` or `""` shows as "（空）"
#'   ("(empty)").
#' @param title The table name, placed in `<caption>` (e.g. "第 1 波（t1）" ("Wave 1 (t1)"),
#'   "結果" ("Result")).
#' @param added Names of columns added in this step (e.g. `wave`).
#' @param row_header Whether column 1 holds row headers (`<th scope="row">`).
#' @return `<table class="kit-dg-table">`.
#' @examples
#' kit_dg_table(data.frame(id = 1:2, score = c(3, NA)), "第 1 波（t1）")  # "Wave 1 (t1)"
#' @export
kit_dg_table <- function(df, title, added = NULL, row_header = FALSE) {
  df <- as.data.frame(df, stringsAsFactors = FALSE, check.names = FALSE)
  cols <- names(df)
  is_added <- cols %in% added
  cell <- function(v, j) {
    v <- as.character(v)
    # 原文：（空）
    content <- if (is.na(v) || !nzchar(v)) shiny::tags$span(class = "kit-dg-empty", "\uff08\u7a7a\uff09") else v
    cls <- if (is_added[j]) "kit-dg-added"
    if (row_header && j == 1L) shiny::tags$th(scope = "row", class = cls, content)
    else shiny::tags$td(class = cls, content)
  }
  shiny::tags$table(
    class = "kit-dg-table",
    shiny::tags$caption(title),
    shiny::tags$thead(shiny::tags$tr(lapply(seq_along(cols), function(j) {
      shiny::tags$th(
        scope = "col", class = if (is_added[j]) "kit-dg-added",
        # 原文：（新）
        cols[j], if (is_added[j]) shiny::tags$span(class = "kit-dg-new", "\uff08\u65b0\uff09")
      )
    }))),
    shiny::tags$tbody(lapply(seq_len(nrow(df)), function(i) {
      shiny::tags$tr(lapply(seq_along(cols), function(j) cell(df[[j]][i], j)))
    }))
  )
}

#' Diagram: small table before → small table after, with a plain-language line below
#'
#' Goes in the `diagram` of [kit_tab_guide()]. On narrow screens (≤ 576px) "before" is on top, the
#' arrow points down, and "after" is below.
#' Each small table has 2–3 rows and uses generic names (id, score, wave), not column names from a
#' particular database.
#'
#' @param before The small table(s) before: one [kit_dg_table()] or a list of them (side by side).
#' @param after The small table after: one [kit_dg_table()].
#' @param caption One plain-language line (`<figcaption>`).
#' @param arrow The arrow in the middle.
#' @return `<figure class="kit-diagram">`.
#' @examples
#' kit_diagram(
#'   list(kit_dg_table(data.frame(id = 1:2, t1 = c(3, 5)), "第 1 波"),
#'        kit_dg_table(data.frame(id = c(1, 3), t2 = c(4, 6)), "第 2 波")),
#'   kit_dg_table(data.frame(id = 1:3, t1 = c(3, 5, NA), t2 = c(4, NA, 6)), "結果"),
#'   "依 id 接起來：沒有出席的那一波是空的。"
#' )
#' # "Wave 1", "Wave 2", "Result";
#' # caption: "Joined by id: a wave the child missed is empty."
#' @export
# 原文：→
kit_diagram <- function(before, after, caption, arrow = "\u2192") {
  if (inherits(before, "shiny.tag")) before <- list(before)
  shiny::tags$figure(
    class = "kit-diagram",
    shiny::tags$div(
      class = "kit-dg-flow",
      shiny::tags$div(class = "kit-dg-before", before),
      shiny::tags$div(class = "kit-dg-arrow", `aria-hidden` = "true", arrow),
      shiny::tags$div(class = "kit-dg-after", after)
    ),
    shiny::tags$figcaption(class = "kit-dg-caption", caption)
  )
}
