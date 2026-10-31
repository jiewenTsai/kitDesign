# kitDesign 元件樣張：每一個元件放一次，內容是 KIT 的例子
#
# shiny::runApp(system.file("examples/gallery", package = "kitDesign"))
# 或 kitDesign::kit_gallery()
#
# 有狀態的元件用模組：步驟分頁（kit_step_tabs_*）、主要按鈕＋還差（kit_run_gate_*）、
# 步驟卡（kit_stepcards_*）、用 R 怎麼做（kit_code_panel_*）。
# 狀態框、檢查清單、程式碼是值物件（kit_status、kit_checklist、kit_code），直接放進頁面。

library(shiny)
library(kitDesign)

`%||%` <- function(x, y) if (is.null(x)) y else x

# 分頁列：分組、不編號（kitJoin 的樣子）
groups <- list(
  kit_navgroup("頁面", c(page = "頁面骨架", status = "狀態框與按鈕")),
  kit_navgroup("步驟", c(steps = "步驟卡", checklist = "檢查清單", flow = "流程分頁")),
  kit_navgroup("參考", c(code = "程式碼與表格", chart = "圖"), tools = TRUE)
)

# 例子用的資料
waves <- data.frame(
  id = c(101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112),
  cohort = rep(c("M03", "M36"), 6),
  wave_m = rep(c(3, 6, 12), 4),
  score_t1 = c(12, 15, NA, 9, 11, 14, 10, 8, 13, 16, 7, 12),
  income = c(32000, 45500, 28750, 51200, 39900, 27400, 61000, 33300, 42800, 30500, 47700, 36100)
)
wide <- as.data.frame(matrix(rep(0:3, length.out = 3 * 30), nrow = 3,
                             dimnames = list(NULL, sprintf("w1d5_%02d", 1:30))))
wide <- cbind(subj_id = c("A0001", "A0002", "A0003"), wide)

# 很長的程式碼：括號裡的逗號後面會自動換行（kit_code_wrap()）；
# 最後一行的長路徑斷不開，在程式碼框裡左右捲（框不能撐破版面）
long_code <- paste0(
  "# 這一段故意很長：檢查自動換行與程式碼框會不會撐破版面\n",
  "joined <- dplyr::left_join(t1, t2, by = c(\"cohort\", \"subj_id\"), suffix = c(\"_t1\", \"_t2\"), ",
  "relationship = \"one-to-one\", unmatched = \"drop\", multiple = \"error\", na_matches = \"never\")\n",
  "readr::write_csv(joined, \"/Users/kit/Documents/projects/tdcyp/output/joined_wide_",
  "cohort_M03_M36_waves_3_6_12_20261031.csv\")"
)

page_ui <- tagList(
  kit_tab_guide(
    goal = "把兩個波次的檔案依 ID 接成一張寬資料。",
    steps = kit_steps("選 ID 欄", "選要保留哪些人", "按「執行串接」", "看狀態框與結果"),
    output = "一張寬資料：一人一列，每個波次的欄後面加上 _t1、_t2。",
    note = "只要一個波次時，不用串接，直接下載那個檔案。",
    technical = "用 dplyr::left_join() 依 cohort、subj_id 串接；ID 欄先統一成文字再比對。",
    diagram = kit_diagram(
      list(kit_dg_table(data.frame(id = 1:2, score = c(3, 5)), "第 1 波（t1）"),
           kit_dg_table(data.frame(id = c(1, 3), score = c(4, 6)), "第 2 波（t2）")),
      kit_dg_table(data.frame(id = 1:2, score_t1 = c(3, 5), score_t2 = c(4, NA), wave = c(2, 1)),
                   "結果", added = "wave"),
      "依 id 接起來：第 2 波沒有出席的人，t2 的格子是空的。"
    )
  ),
  fluidRow(
    column(
      4,
      h4("設定"),
      selectInput("id_col", "ID 欄", c("（還沒選）" = "", "subj_id", "id"), width = "100%"),
      tags$p(class = "kit-hint", "每個檔案的 ID 欄名稱要一樣。"),
      radioButtons("keep", "要保留哪些人？",
                   c("向後追蹤樣本（建議）" = "left", "全勤樣本" = "inner", "全樣本" = "full")),
      kit_advanced(
        checkboxInput("trim", "比對前去掉 ID 前後的空白", TRUE),
        textInput("suffix", "欄名後面加上", "_t1、_t2"),
        id = "advanced"
      )
    ),
    column(
      8,
      h4("預覽"),
      tags$p(class = "kit-hint", kit_rows_note(nrow(waves), ncol(waves), shown_rows = 5)),
      kit_table_scroll(kit_static_table(head(waves, 5)))
    )
  ),
  kit_callout("資料裡有 3 格看起來是遺漏值代碼（9999）。若它們代表遺漏，請先",
              actionLink("goto_missing", "到「遺漏值處理」處理"), "。", warn = TRUE),
  uiOutput("settings"),
  # 模組：主要按鈕＋還差
  kit_run_gate_ui("gate", "執行串接"),
  uiOutput("status"),
  uiOutput("result")
)

status_ui <- tagList(
  kit_tab_guide("看四種狀態框、按鈕與提示框長什麼樣子。",
                c("看狀態框", "按按鈕", "看提示框"), "每個元件一個例子。"),
  h4("狀態框"),
  # kit_status 物件直接放進頁面
  kit_done_status("串接完成：結果共 3,389 列 × 2,058 欄。",
                  points = c("688 人每個檔案都有資料。", "第 1 波 3,389 人，第 2 波 3,102 人。")),
  kit_done_status(
    "串接完成：結果共 3,389 列 × 2,058 欄。",
    warnings = c("有 12 人的 ID 重複，只留第一筆。", "第 3 波沒有 sex 欄。"),
    points = c("688 人每個檔案都有資料。", "第 1 波 3,389 人。", "第 2 波 3,102 人。",
               "第 3 波 2,950 人。"),
    notes = "ID 欄比對前已經去掉前後空白。"
  ),
  kit_error_status(
    tryCatch(stop("object 'subj_id' not found"), error = identity), "串接",
    todo = actionLink("goto_upload", "回「檔案上傳」看一下檔案 →")
  ),
  kit_stale_status("執行串接"),
  h4("按鈕"),
  tags$div(
    style = "display: flex; flex-wrap: wrap; align-items: center; gap: 0.6rem 1rem;",
    kit_button("demo_primary", "開始校準", "primary"),
    actionButton("demo_default", "對，下一步"),
    kit_button("demo_secondary", "下載 CSV"),
    # 危險按鈕：鮭魚色底、墨色字（停用時照停用的樣子）
    kit_button("demo_danger", "這一回合不做", "danger"),
    kit_button("demo_danger_off", "移除", "danger", disabled = TRUE),
    kit_button("demo_disabled", "執行轉換", "primary", disabled = TRUE)
  ),
  kit_ready_line("至少要 2 個波次的檔案，目前只有 1 個",
                 actionLink("goto_upload2", "到「檔案上傳」加入檔案 →")),
  kit_button("demo_gate", "執行串接", "primary", disabled = TRUE),
  h4("提示框"),
  kit_callout("外部連結不適用：這一回合只有一個世代，這不是錯誤。"),
  kit_callout("資料裡有疑似遺漏值代碼，建議先到「遺漏值處理」。", warn = TRUE),
  h4("雲端版橫幅"),
  kit_cloud_banner("此為雲端版：上傳的資料會傳送至雲端伺服器。含個資的資料請改用本機版。"),
  h4("連到別的 app"),
  tags$p(kit_app_link("開啟 kitsUI", "https://example.org/kitsui/", kind = "secondary",
                      note = "（開啟網路上的雲端版 kitsUI）")),
  kit_next_step("看完狀態框，接著看步驟卡。", "next_steps", "下一步：步驟卡")
)

steps_ui <- tagList(
  kit_tab_guide("把各波次的資料轉成作答檔：三個步驟，一次做一步。",
                c("每個檔案是哪個世代、哪個波次", "哪些欄是題目", "計分檢查"),
                "一個作答檔（.csv.gz）。"),
  # 模組：步驟卡（哪一步打開、做完、還不能做，由模組管）
  kit_stepcards_ui(
    "cards",
    tagList(
      tags$p("已經照欄名猜好了（淡黃色），請看一遍，不對就改。"),
      tags$table(
        class = "table table-sm kit-file-table",
        tags$thead(tags$tr(tags$th("檔案"), tags$th("世代"), tags$th("波次"))),
        tags$tbody(
          tags$tr(tags$td(`data-label` = "檔案", "w1_jsq.sav"),
                  tags$td(`data-label` = "世代", class = "kit-guess", "TDCYP"),
                  tags$td(`data-label` = "波次", "2009")),
          tags$tr(tags$td(`data-label` = "檔案", "w2_jsq.sav"),
                  tags$td(`data-label` = "世代", class = "kit-guess", "TDCYP"),
                  tags$td(`data-label` = "波次", "2011"))
        )
      )
    ),
    tagList(
      tags$p("挑出哪些欄是題目（至少一題）。"),
      checkboxGroupInput("items", NULL, c("w1d5_01", "w1d5_02", "w1d5_03"), inline = TRUE)
    ),
    tags$p("看計分檢查（見「檢查清單」分頁）。")
  ),
  uiOutput("cards_note")
)

checklist_ui <- tagList(
  kit_tab_guide("轉換前，看下面每一件事。", c("看要決定的事", "按決定的按鈕"), "可以轉換的作答檔。"),
  h4("計分檢查"),
  # kit_checklist 物件直接放進頁面
  kit_checklist(
    kit_check("todo", "有 3 題的分數從 1 開始",
              "kits 要的分數是 0、1、2…。可以全部減 1，或照原樣。",
              actions = list(kit_button("shift", "全部減 1（建議）"), kit_button("keep_as_is", "照原樣"))),
    kit_check("todo", "有 2 欄的值 9999 看起來是遺漏值代碼",
              "值標籤寫著「遺漏值」。先用「遺漏值處理」改成 NA，或照原樣當成分數。",
              actions = kit_button("to_na", "改成遺漏值（建議）")),
    kit_check("ok", "45 題的分數都是整數"),
    kit_check("ok", "反向題：w1d5_07、w1d5_12（你選的）",
              actions = actionLink("undo_rev", "改回來")),
    kit_check("note", "有 2 題沒有人作答，不會放進作答檔")
  ),
  kit_problems("第 2 列沒有選世代", "第 4 列的波次不是數字", head = "還差：")
)

flow_ui <- tagList(
  kit_tab_guide("有順序的流程用圈數字分頁；做完的打 ✓，還不能做的灰色。",
                c("在下面改分頁的狀態", "滑過灰色的分頁看說明"), "兩種分頁列的狀態。"),
  # 模組：有順序的流程分頁
  kit_step_tabs_ui(
    "flow",
    tabPanel("① 資料", value = "data", tags$p("① 資料：選這一回合的作答檔。")),
    tabPanel("② 題目校準", value = "items", tags$p("② 題目校準。")),
    tabPanel("③ 連結", value = "link", tags$p("③ 連結。")),
    tabPanel("④ 受試者評分", value = "score", tags$p("④ 受試者評分。")),
    tabPanel("使用手冊", value = "manual", tags$p("使用手冊（不是流程的一步）。")),
    aside = "manual"
  ),
  h4("改分頁的狀態"),
  tags$div(
    class = "kit-inline",
    selectInput("state_tab", "哪一個分頁", c("③ 連結" = "link", "④ 受試者評分" = "score")),
    selectInput("state_value", "狀態", c("做完" = "success", "要注意" = "warning",
                                         "要重新執行" = "stale", "還不能做" = "locked",
                                         "可以做" = "idle")),
    kit_button("apply_state", "套用")
  ),
  tags$p(class = "kit-hint", textOutput("flow_selected", inline = TRUE))
)

code_ui <- tagList(
  kit_tab_guide("程式碼框、資料表、圖解。", c("打開「用 R 怎麼做」", "看表格"), "每個元件一個例子。"),
  h4("資料表"),
  tags$p(class = "kit-hint", kit_rows_note(nrow(waves), ncol(waves), shown_rows = 10)),
  kit_table_scroll(tableOutput("preview")),
  h4("很寬的表"),
  tags$p(class = "kit-hint", kit_rows_note(nrow(wide), ncol(wide), shown_rows = 3, shown_cols = 20)),
  kit_table_scroll(kit_static_table(kit_preview_table(wide, priority_cols = "subj_id"))),
  h4("串接方式的小比較"),
  tags$div(
    class = "kit-dg-compare",
    kit_dg_table(
      data.frame("方式" = c("向後追蹤樣本（建議）", "全勤樣本", "全樣本"),
                 "留下的人" = c("1、2 號", "1 號", "1、2、3 號"), check.names = FALSE),
      "三種方式各留下誰", row_header = TRUE
    )
  ),
  h4("程式碼（kit_code 物件）"),
  kit_code("scores <- kits::kits_subj(X, item, persons = persons)", "kits 版"),
  kit_details_row(
    kit_detail("這一回合的紀錄", tags$p("2026-10-31 14:02 串接 2 個檔案。")),
    # 模組：用 R 怎麼做（一開始打開：長的程式碼自動換行，斷不開的在框裡左右捲）
    kit_code_panel_ui("code_long", open = TRUE)
  )
)

# plotly 是 Suggests：沒有裝時，圖的位置寫一句怎麼裝
has_plotly <- requireNamespace("plotly", quietly = TRUE)
chart_output <- function(id, height) {
  if (has_plotly) {
    plotly::plotlyOutput(id, height = height)
  } else {
    kit_callout("這個例子要 plotly 套件：install.packages(\"plotly\")", warn = TRUE)
  }
}

chart_ui <- tagList(
  kit_tab_guide(
    "圖的類別色用 Okabe–Ito，依序取色；plotly 圖最後交給 kit_plotly_style()，和 app 看起來是一套。",
    c("看顏色", "看兩張例圖（線圖、熱圖）"), "兩張套好 KIT 樣子的 plotly 圖。"
  ),
  h4("類別色"),
  tags$div(
    class = "kit-inline",
    lapply(names(kit_chart_colors()), function(nm) {
      tags$div(
        tags$div(style = paste0("width:4rem;height:2rem;border:2px solid #141414;border-radius:8px;",
                                "background:", kit_chart_colors()[[nm]])),
        tags$small(class = "kit-hint", nm)
      )
    }),
    tags$div(
      tags$div(style = paste0("width:4rem;height:2rem;border:2px solid #141414;border-radius:8px;",
                              "background:", kit_chart_neutral())),
      tags$small(class = "kit-hint", "neutral")
    )
  ),
  h4("各世代的分數中位數"),
  chart_output("chart_line", "360px"),
  tags$p(class = "kit-hint", "每一條線是一個世代；灰色虛線是參考線。"),
  h4("每個波次的題目通過比例"),
  chart_output("chart_heat", "340px"),
  tags$p(class = "kit-hint", "顏色越深，通過的人越多；白色是沒有施測（或沒有人通過）。")
)

ver <- kit_app_description("kitDesign")
ui <- kit_page(
  "KIT 元件樣張", "kitDesign",
  tagline = "KIT 研究工具共用的介面",
  version = ver$version, date = ver$date, show_kitdesign = TRUE,
  # 模組：分組的步驟分頁
  kit_step_tabs_ui(
    "nav",
    tabPanel("頁面骨架", value = "page", page_ui),
    tabPanel("狀態框與按鈕", value = "status", status_ui),
    tabPanel("步驟卡", value = "steps", steps_ui),
    tabPanel("檢查清單", value = "checklist", checklist_ui),
    tabPanel("流程分頁", value = "flow", flow_ui),
    tabPanel("程式碼與表格", value = "code", code_ui),
    tabPanel("圖", value = "chart", chart_ui),
    groups = groups, selected = "page"
  )
)

server <- function(input, output, session) {
  goto <- function(tab) nav$select(tab)

  # 頁面骨架 ----
  missing <- reactive(c(if (!nzchar(input$id_col %||% "")) "選 ID 欄"))
  run <- kit_run_gate_server("gate", missing,
                             link = function() actionLink("open_adv", "看進階設定 →"))
  observeEvent(input$open_adv, kit_open_details("advanced"))
  output$settings <- renderUI(kit_settings_line(c(
    "2 個檔案", if (nzchar(input$id_col %||% "")) paste0("ID：", input$id_col),
    c(left = "向後追蹤樣本", inner = "全勤樣本", full = "全樣本")[[input$keep]]
  )))

  status <- reactiveVal(kit_status())
  result <- reactiveVal(NULL)
  observeEvent(run(), {
    st <- tryCatch({
      out <- waves
      kit_done_status(
        paste0("串接完成：結果共 ", kit_dims(nrow(out), ncol(out)), "。"),
        warnings = "有 1 格是空的（id 103 的 score_t1）。",
        points = c("12 人每個檔案都有資料。", "M03 6 人、M36 6 人。",
                   "收入的中位數是 38,000 元。", "第 2 波沒有新加入的人。")
      )
    }, error = function(e) kit_error_status(e, "串接"))
    status(st)
    result(waves)
    kit_notify(st)
    kit_scroll_to("status")
  }, ignoreInit = TRUE)
  # 改了設定：舊結果失效
  observeEvent(list(input$id_col, input$keep), {
    if (!is.null(result())) {
      result(NULL)
      status(kit_stale_status("執行串接"))
    }
  }, ignoreInit = TRUE)
  output$status <- renderUI(status())
  output$result <- renderUI({
    df <- result()
    if (is.null(df)) return(NULL)
    tagList(
      h4("串接結果"),
      tags$p(class = "kit-hint", kit_rows_note(nrow(df), ncol(df), shown_rows = 5)),
      kit_table_scroll(kit_static_table(head(df, 5))),
      kit_details_row(
        kit_detail("預覽（前 10 列）",
                   kit_table_scroll(renderTable(kit_preview_table(df, n = 10), na = ""))),
        kit_detail("這一回合的紀錄", tags$p("2026-10-31 串接 2 個檔案。")),
        kit_code_panel_ui("code")
      ),
      kit_next_step(
        tags$ul(tags$li("要做 kits 作答檔：到「步驟卡」。"), tags$li("要長格式：到「流程分頁」。")),
        "next_page", "下一步：步驟卡"
      )
    )
  })
  kit_code_panel_server("code", function() list(
    tidy = paste0("joined <- dplyr::left_join(t1, t2, by = \"", input$id_col, "\")"),
    base = paste0("joined <- merge(t1, t2, by = \"", input$id_col, "\", all.x = TRUE)")
  ))
  kit_code_panel_server("code_long", function() list(R = long_code))

  observeEvent(input$next_page, goto("steps"))
  observeEvent(input$next_steps, goto("steps"))

  # 步驟卡 ----
  cards <- kit_stepcards_server(
    "cards",
    titles = c("每個檔案是哪個世代、哪個波次", "哪些欄是題目", "計分檢查"),
    summaries = list("2 個檔案 · 世代 TDCYP · 2009、2011（年）",
                     function() paste0(length(input$items), " 題"),
                     "沒有要決定的事"),
    checks = list(NULL, function() if (length(input$items) == 0) "至少挑一題")
  )
  output$cards_note <- renderUI(tags$p(
    class = "kit-hint",
    paste0("現在：", if (cards$current() == 0) "三步都做完了" else paste0("第 ", cards$current(), " 步"),
           "；做完：", paste(which(cards$done()), collapse = "、") %||% "")
  ))

  # 分頁狀態 ----
  nav <- kit_step_tabs_server("nav", states = reactive(c(
    page = status()$state,
    steps = if (all(cards$done())) "success" else "idle"
  )))
  flow_states <- reactiveValues(data = "success", items = "warning", link = "stale", score = "locked")
  observeEvent(input$apply_state, flow_states[[input$state_tab]] <- input$state_value)
  flow <- kit_step_tabs_server(
    "flow",
    states = reactive(unlist(reactiveValuesToList(flow_states))),
    tips = "先做「② 題目校準」"
  )
  output$flow_selected <- renderText(paste0("現在的分頁：", flow$selected() %||% ""))

  # 程式碼與表格、圖 ----
  output$preview <- renderTable(kit_preview_table(waves, n = 10), striped = TRUE, spacing = "s", na = "")
  # plotly 圖：kit_plotly_style() 換字型、軸線、底色、圖例、色階、工具列
  if (has_plotly) {
    output$chart_line <- plotly::renderPlotly({
      d <- data.frame(wave_m = c(3, 6, 12, 36, 48, 36, 48, 84, 96),
                      median = c(8, 11, 15, 22, 26, 21, 25, 31, 34),
                      cohort = c(rep("M03", 5), rep("M36", 4)))
      p <- plotly::plot_ly(d, x = ~wave_m, y = ~median, split = ~cohort,
                           type = "scatter", mode = "lines+markers")
      p <- plotly::add_lines(p, x = c(3, 96), y = c(20, 20), split = NULL, name = "參考線",
                             line = list(color = kit_chart_neutral(), dash = "dash"),
                             inherit = FALSE)
      p <- plotly::layout(p, title = "各世代每個波次的分數中位數",
                          xaxis = list(title = "波次（月）"), yaxis = list(title = "分數中位數"))
      kit_plotly_style(p, filename = "kit-gallery-line")
    })
    output$chart_heat <- plotly::renderPlotly({
      items <- sprintf("lana%02d", 1:8)
      waves <- c("3", "6", "12", "36", "48")
      z <- rbind(c(0.10, 0.05, 0.02, NA, NA, NA, NA, NA),
                 c(0.45, 0.30, 0.12, 0.05, NA, NA, NA, NA),
                 c(0.85, 0.70, 0.45, 0.30, 0.10, NA, NA, NA),
                 c(NA, NA, NA, 0.95, 0.80, 0.55, 0.35, 0.20),
                 c(NA, NA, NA, 0.98, 0.92, 0.75, 0.60, 0.40))
      p <- plotly::plot_ly(x = items, y = waves, z = z, type = "heatmap", zmin = 0, zmax = 1,
                           colorbar = list(title = "通過比例"))
      p <- plotly::layout(p, title = "每個波次的題目，顏色是通過比例",
                          xaxis = list(title = "題目", type = "category"),
                          yaxis = list(title = "波次（月）", type = "category"))
      kit_plotly_style(p, filename = "kit-gallery-heatmap")
    })
  }
}

shinyApp(ui, server)
