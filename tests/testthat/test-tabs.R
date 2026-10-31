groups <- list(
  kit_navgroup("準備", c(upload = "檔案上傳", missing = "遺漏值處理")),
  kit_navgroup("其他工具", c(convert = "檔案格式轉換"), tools = TRUE)
)

test_that("kit_navgroup() validates its tabs", {
  g <- kit_navgroup("準備", c(upload = "檔案上傳"))
  expect_s3_class(g, "kit_navgroup")
  expect_null(g$class)
  expect_equal(kit_navgroup("x", c(a = "A"), tools = TRUE)$class, "tools")
  expect_error(kit_navgroup("x", c("沒有名字")))
})

test_that("kit_navgroups() draws grouped, un-numbered tabs", {
  out <- html(kit_navgroups(groups, "tabs", selected = "missing"))
  expect_match(out, "^<nav class=\"kit-navgroups\" data-tabset=\"tabs\" aria-label=\"分頁\">")
  expect_match(out, "<div class=\"kit-navgroup\">\\s*<div class=\"kit-navgroup-label\">準備</div>")
  expect_match(out, "<div class=\"kit-navgroup tools\">", fixed = TRUE)
  expect_match(out, "<ul class=\"nav nav-tabs\">", fixed = TRUE)
  expect_match(out, "<a class=\"nav-link active\" href=\"#\" data-kit-tab=\"missing\" aria-current=\"page\">遺漏值處理</a>",
               fixed = TRUE)
  expect_match(out, "<a class=\"nav-link\" href=\"#\" data-kit-tab=\"upload\">檔案上傳</a>", fixed = TRUE)
  first <- html(kit_navgroups(groups))
  expect_match(first, "class=\"nav-link active\" href=\"#\" data-kit-tab=\"upload\"", fixed = TRUE)
  single <- html(kit_navgroups(groups[[1]]))
  expect_match(single, "data-kit-tab=\"missing\"", fixed = TRUE)
})

test_that("kit_flow_tabs() wraps a visible tabsetPanel and marks aside tabs", {
  tabs <- kit_flow_tabs(
    shiny::tabPanel("① 資料", value = "data"), shiny::tabPanel("使用手冊", value = "manual"),
    id = "flow", aside = "manual"
  )
  out <- html(tabs)
  expect_match(out, "^<div class=\"kit-flow-tabs\" data-kit-aside=\"manual\">")
  expect_match(out, "id=\"flow\"", fixed = TRUE)
  expect_match(out, "data-value=\"data\"", fixed = TRUE)
  expect_match(out, "nav-tabs", fixed = TRUE)
  expect_false(grepl("data-kit-aside", html(kit_flow_tabs(shiny::tabPanel("a"), id = "x")), fixed = TRUE))
})

test_that("kit_tab_states() maps statuses to done, stale, locked, ready with tips", {
  st <- kit_tab_states(
    list(upload = "success", missing = "warning", join = "stale", stack = "error",
         attrition = "idle", reshape = "done"),
    locked = c("convert", "stack"),
    locked_tips = c(convert = "還不能用：先在「檔案上傳」加入檔案"),
    tabset = "tabs"
  )
  by <- setNames(st, vapply(st, `[[`, "", "value"))
  expect_equal(vapply(by, `[[`, "", "state"),
               c(upload = "done", missing = "done", join = "stale", stack = "locked",
                 attrition = "ready", reshape = "done", convert = "locked"))
  expect_equal(by$upload$tip, "已完成")
  expect_equal(by$missing$tip, "已完成，但有要注意的地方")
  expect_equal(by$join$tip, "設定或檔案改過了：要重新執行")
  expect_equal(by$convert$tip, "還不能用：先在「檔案上傳」加入檔案")
  expect_equal(by$stack$tip, "還不能用：先完成前面的步驟")
  expect_null(by$attrition$tip)
  expect_true(all(vapply(st, `[[`, "", "tabset") == "tabs"))
  # 一句說明給全部；具名 logical；直接寫分頁狀態（kitsUI）
  st2 <- kit_tab_states(c(data = "done", items = "ready", link = "locked"),
                        locked = c(score = TRUE, data = FALSE), locked_tips = "先做「② 題目校準」",
                        tabset = "flow")
  by2 <- setNames(st2, vapply(st2, `[[`, "", "value"))
  expect_equal(by2$data$state, "done")
  expect_equal(by2$items$state, "ready")
  expect_equal(by2$link$state, "locked")
  expect_equal(by2$score$state, "locked")
  expect_equal(by2$score$tip, "先做「② 題目校準」")
})

test_that("kit_send_tab_states() sends one kit-tab-states message", {
  s <- fake_session()
  st <- kit_tab_states(list(upload = "success"))
  expect_identical(kit_send_tab_states(st, session = s), st)
  expect_length(s$messages, 1)
  expect_equal(s$messages[[1]]$type, "kit-tab-states")
  expect_equal(s$messages[[1]]$message[[1]]$state, "done")
  expect_identical(kit_send_tab_states(st, session = NULL), st)
})

test_that("kit_watch_tab_states() re-sends when the states change", {
  s <- fake_session()
  shiny::testServer(function(id) shiny::moduleServer(id, function(input, output, session) {
    state <- shiny::reactiveVal("idle")
    session$userData$state <- state
    kit_watch_tab_states(s, shiny::reactive(kit_tab_states(list(join = state()))))
  }), {
    session$flushReact()
    n <- length(s$messages)
    expect_gte(n, 1)
    expect_equal(s$messages[[n]]$message[[1]]$state, "ready")
    session$userData$state("success")
    session$flushReact()
    expect_equal(length(s$messages), n + 1)
    expect_equal(s$messages[[n + 1]]$message[[1]]$state, "done")
  })
})
