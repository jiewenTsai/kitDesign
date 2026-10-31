# 頁面說明（這一頁做什麼）與圖解

#' 頁面說明：這一頁做什麼（PageGuide）
#'
#' 每個分頁最上面的一行說明，預設收起：只看到「這一頁做什麼：」一句，旁邊「看步驟 ▸」；
#' 打開才看到步驟、會得到什麼、補充與技術說明。沒有框、小字、灰色，下面一條淡線。
#'
#' @param goal 一句話，不超過 30 字。
#' @param steps 操作步驟：[kit_steps()]（3–6 點），或一個字串向量（自動變成 [kit_steps()]）。
#' @param output 會得到什麼。
#' @param technical 技術說明（給想了解原理的人，再收一層）；`NULL` 不顯示。
#' @param note 補充（灰色小字）；`NULL` 不顯示。
#' @param diagram 圖解（[kit_diagram()]）：放在說明框外面、緊接在後面，收起時也看得到；
#'   `NULL` 不顯示。
#' @return 沒有圖解時是 `<details class="kit-guide kit-guide-page">`；有圖解時外面再包一層
#'   `<div class="kit-guide kit-guide-wrap">`。
#' @seealso [kit_steps()]、[kit_diagram()]
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

#' 編號的步驟清單（放在 [kit_tab_guide()] 的 `steps`）
#'
#' 注意：這是說明框裡的 `<ol>`，不是步驟卡；步驟卡是 [kit_step_card()]。
#'
#' @param ... 每一步一個字串（或字串向量）。
#' @return `<ol class="kit-steps">`。
#' @examples
#' kit_steps("選檔案", "選 ID 欄", "按「執行串接」")
#' @export
kit_steps <- function(...) {
  shiny::tags$ol(class = "kit-steps", lapply(c(...), shiny::tags$li))
}

#' 圖解用的小表格（2–3 欄、2–4 列）
#'
#' 配角：不加框、表格跟著內容寬、1px 細線、淡色表頭（不是大資料表的黑表頭）；
#' 值用等寬字。新加的欄淡萊姆底，欄名後面加「（新）」，不只靠顏色；
#' 空的格子寫灰色的「（空）」。
#'
#' @param df data.frame（值會轉成文字）；`NA` 或 `""` 顯示成「（空）」。
#' @param title 表名，放在 `<caption>`（例如「第 1 波（t1）」「結果」）。
#' @param added 這一步新加的欄名（例如 `wave`）。
#' @param row_header 第 1 欄是列標題（`<th scope="row">`）。
#' @return `<table class="kit-dg-table">`。
#' @examples
#' kit_dg_table(data.frame(id = 1:2, score = c(3, NA)), "第 1 波（t1）")
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

#' 圖解：處理前的小表 → 處理後的小表，下面一行白話說明（Diagram）
#'
#' 放進 [kit_tab_guide()] 的 `diagram`。窄螢幕（≤ 576px）時「前」在上、箭頭朝下、「後」在下。
#' 每張小表 2–3 列，用一般的名稱（id、score、wave），不用某個資料庫的欄名。
#'
#' @param before 處理前的小表：一個 [kit_dg_table()] 或它們的 list（並排）。
#' @param after 處理後的小表：一個 [kit_dg_table()]。
#' @param caption 一行白話說明（`<figcaption>`）。
#' @param arrow 中間的箭頭。
#' @return `<figure class="kit-diagram">`。
#' @examples
#' kit_diagram(
#'   list(kit_dg_table(data.frame(id = 1:2, t1 = c(3, 5)), "第 1 波"),
#'        kit_dg_table(data.frame(id = c(1, 3), t2 = c(4, 6)), "第 2 波")),
#'   kit_dg_table(data.frame(id = 1:3, t1 = c(3, 5, NA), t2 = c(4, NA, 6)), "結果"),
#'   "依 id 接起來：沒有出席的那一波是空的。"
#' )
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
