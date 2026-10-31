# Build a KIT app page with kitDesign

This guide follows the page skeleton from the “KIT design language” and
builds one page step by step:

    header → step tabs → what this page does → settings → still needed + primary button
    → status box → key result (one table) → details row (How to do it in R) → next step

For an app you can run right away, use
`kit_new_app("~/kitScore", "KIT 計分工具")`; the app it creates is the
page below. To see every component:
[`kit_gallery()`](https://jiewentsai.github.io/kitDesign/reference/kit_gallery.md).

## 1. Page: `kit_page()`

Sets up the theme, styles, and header in one call. The version line
reads the app’s own DESCRIPTION, followed by the kitDesign version.

``` r

library(shiny)
library(kitDesign)

ver <- kit_app_description("kitScore")
ui <- kit_page(
  "KIT 計分工具", "臺灣幼兒發展調查資料庫",   # "KIT Scoring Tool", "Kids in Taiwan"
  version = ver$version, date = ver$date, show_kitdesign = TRUE,
  tabs_ui   # step 2
)
```

## 2. Step tabs: `kit_step_tabs_ui()` / `kit_step_tabs_server()`

Use circled numbers for a flow with a fixed order; when not every page
has to be done, use `groups` (grouped, not numbered).

``` r

tabs_ui <- kit_step_tabs_ui(
  "nav",
  tabPanel("① 計分", value = "score", score_ui("score")),   # steps 3–8 ("Scoring")
  tabPanel("② 結果", value = "result", p("…"))               # ("Results")
)

# server: done steps get a ✓; steps that can't be done yet are gray, and hovering explains why
nav <- kit_step_tabs_server(
  "nav",
  states = reactive(c(score = score$state(),
                      result = if (score$state() == "success") "ready" else "locked")),
  tips = c(result = "先在「① 計分」按「開始計分」")   # "First click 'Start scoring' in '① Scoring'"
)
```

## 3–5. What this page does, settings, still needed + primary button

``` r

score_ui <- function(id) {
  ns <- NS(id)
  tagList(
    kit_tab_guide(
      goal = "把作答檔算成分數。",                               # "Turn the response file into scores."
      steps = c("選量尺", "按「開始計分」", "看狀態框與結果"),   # "Pick a scale", "Click 'Start scoring'", "Check the status box and results"
      output = "一張分數表。"                                    # "A table of scores."
    ),
    selectInput(ns("scale"), "量尺", c("（還沒選）" = "", "gm", "fm")),   # "Scale", "(not chosen yet)"
    kit_run_gate_ui(ns("run"), "開始計分"),    # Still needed: … + disabled primary button
    uiOutput(ns("status")),
    uiOutput(ns("result")),
    kit_details_row(
      kit_detail("這一回合的紀錄", "…"),      # "Log for this run"
      kit_code_panel_ui(ns("code"))         # How to do it in R: always last
    ),
    uiOutput(ns("next_step"))
  )
}
```

## 6–9. Server: status box, result table, How to do it in R, next step

The status box is a `kit_status` object; pass it straight to
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html).

``` r

score_server <- function(id, goto) {
  moduleServer(id, function(input, output, session) {
    run <- kit_run_gate_server("run", reactive(if (input$scale == "") "選量尺"))
    status <- reactiveVal(kit_status())
    result <- reactiveVal(NULL)

    observeEvent(run(), {
      st <- tryCatch({
        df <- data.frame(id = 1:3, score = c(12, 15, 9))   # replace with real scoring
        result(df)
        kit_done_status(paste0("計分完成：", kit_num(nrow(df)), " 人。"))   # "Scoring done: N people."
      }, error = function(e) kit_error_status(e, "計分"))
      status(st)
      kit_scroll_to("status")                  # results first, details after
    }, ignoreInit = TRUE)

    output$status <- renderUI(status())
    output$result <- renderUI({
      req(result())
      tagList(
        h4("分數"),
        p(class = "kit-hint", kit_rows_note(nrow(result()), shown_rows = 10)),
        kit_table_scroll(kit_static_table(head(result(), 10)))
      )
    })
    kit_code_panel_server("code", function() list(
      tidy = paste0("scores <- kits::kits_subj(X, item) |>\n",
                    "  dplyr::filter(scale == \"", input$scale, "\")")
    ))
    output$next_step <- renderUI({
      req(status()$state %in% c("success", "warning"))
      kit_next_step("算好了。", session$ns("go"), "下一步：結果")   # "Done.", "Next: Results"
    })
    observeEvent(input$go, goto("result"))
    list(state = reactive(status()$state))
  })
}
```

Finally, wire them together:

``` r

server <- function(input, output, session) {
  goto <- function(tab) nav$select(tab)
  score <- score_server("score", goto)
  nav <- kit_step_tabs_server("nav", states = reactive(c(score = score$state())))
}
shinyApp(ui, server)
```

## Value objects can be checked in the console first

``` r

library(kitDesign)
kit_done_status("計分完成：3,389 人。", warnings = "有 12 人沒有作答。")
#> 【完成，但請注意】 計分完成：3,389 人。
#> - 有 12 人沒有作答。
kit_checklist(
  kit_check("todo", "有 3 題的分數從 1 開始", "kits 要的分數是 0、1、2…。"),
  kit_check("ok", "45 題的分數都是整數")
)
#> ! 有 3 題的分數從 1 開始（kits 要的分數是 0、1、2…。）
#> ✓ 45 題的分數都是整數
kit_code("scores <- kits::kits_subj(X, item, persons = persons, method = \"WLE\", se = TRUE)")
#> ## R
#> scores <- kits::kits_subj(X, item, persons = persons, method = "WLE",
#>                           se = TRUE)
```

## Projects other than KIT: change the brand

The logo and colors are not hard-coded. Set the brand once when the app
starts, and
[`kit_page()`](https://jiewentsai.github.io/kitDesign/reference/kit_page.md),
the theme, and chart color scales all follow it; typeface, borders,
shadows, and components follow the design language unchanged. Without a
brand setting, you get KIT.

``` r

options(kitDesign.brand = kit_brand(
  "示範實驗室",                                            # "Demo Lab"
  logo = system.file("logo.svg", package = "kitScore"),   # header logo (SVG or PNG)
  colors = list(accent = "#9cc0ff", primary = "#1f4fa3")
))
```

``` r

kit_brand("示範實驗室", colors = list(accent = "#9cc0ff", primary = "#1f4fa3"))
#> <kit_brand> 示範實驗室
#>   logo: none  (alt: 示範實驗室 標誌)
#>   mark: none
#>   colors (* = not KIT):
#>     ink            #141414
#>     page           #faf7f0
#>     card           #ffffff
#>     accent         #9cc0ff  *
#>     accent_light   #d4e2ff  *
#>     primary        #1f4fa3  *
#>     primary_hover  #1f3b77  *
#>     success        #b9f0a8
#>     warning        #ffde59
#>     danger         #ff9b8f
#>     info           #a8dcff
```

Which colors you can change and where each is used:
[`?kit_brand`](https://jiewentsai.github.io/kitDesign/reference/kit_brand.md).
To see the result: `kit_gallery(brand = "demo")`.
