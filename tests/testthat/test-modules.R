# Shiny 模組：*_ui() 的標記與 *_server() 的行為（shiny::testServer）

test_that("kit_stepcards_ui() makes one card per step with a next button", {
  out <- html(kit_stepcards_ui("cards", shiny::p("一"), shiny::p("二")))
  expect_equal(lengths(regmatches(out, gregexpr("class=\"kit-stepcard\"", out))), 2)
  expect_match(out, "id=\"cards-head1\"", fixed = TRUE)
  expect_match(out, "data-display-if=\"output.open == &#39;2&#39;\" data-ns-prefix=\"cards-\"", fixed = TRUE)
  expect_match(out, "id=\"cards-ok2\"", fixed = TRUE)
  expect_match(out, "對，下一步", fixed = TRUE)
  expect_match(out, "aria-labelledby=\"cards-title1\"", fixed = TRUE)
})

test_that("kit_stepcards_server() opens, completes, checks and edits steps", {
  n_items <- shiny::reactiveVal(0)
  shiny::testServer(kit_stepcards_server, args = list(
    titles = c("世代與波次", "題目", "計分檢查"),
    summaries = list("5 個檔案", function() paste0(n_items(), " 題"), NULL),
    checks = list(NULL, function() if (n_items() == 0) "至少挑一題")
  ), {
    r <- session$returned
    expect_equal(r$current(), 1L)
    expect_equal(r$done(), c(FALSE, FALSE, FALSE))
    expect_equal(output$open, "1")
    expect_match(as.character(output$head1$html), "kit-stephead is-current", fixed = TRUE)
    expect_match(as.character(output$head2$html), "先完成第 1 步", fixed = TRUE)

    session$setInputs(ok1 = 1)
    expect_equal(r$current(), 2L)
    expect_equal(r$done(), c(TRUE, FALSE, FALSE))
    head1 <- as.character(output$head1$html)
    expect_match(head1, "kit-stephead is-done", fixed = TRUE)
    expect_match(head1, "5 個檔案", fixed = TRUE)
    expect_match(head1, paste0("id=\"", session$ns("edit1"), "\""), fixed = TRUE)

    # 檢查沒過：不往下，列出還差什麼
    session$setInputs(ok2 = 1)
    expect_equal(r$current(), 2L)
    expect_match(as.character(output$problems2$html), "至少挑一題", fixed = TRUE)
    n_items(3)
    session$setInputs(ok2 = 2)
    expect_equal(r$current(), 3L)
    expect_false(any(grepl("至少挑一題", as.character(output$problems2$html), fixed = TRUE)))
    expect_match(as.character(output$head2$html), "3 題", fixed = TRUE)

    # 改第 1 步，再按對：打開下一個還沒做完的（第 3 步）
    session$setInputs(edit1 = 1)
    expect_equal(r$current(), 1L)
    session$setInputs(ok1 = 2)
    expect_equal(r$current(), 3L)
    session$setInputs(ok3 = 1)
    expect_equal(r$current(), 0L)
    expect_true(all(r$done()))
    expect_equal(output$open, "0")

    r$open(2)
    expect_equal(r$current(), 2L)
    r$reset()
    expect_equal(r$current(), 1L)
    expect_equal(r$done(), c(FALSE, FALSE, FALSE))
  })
})

test_that("kit_step_tabs_ui() builds the flow and the grouped style", {
  flow <- html(kit_step_tabs_ui("flow", shiny::tabPanel("① 資料", value = "data"),
                                shiny::tabPanel("使用手冊", value = "manual"), aside = "manual"))
  expect_match(flow, "class=\"kit-flow-tabs\" data-kit-aside=\"manual\"", fixed = TRUE)
  expect_match(flow, "id=\"flow-tabs\"", fixed = TRUE)
  grouped <- html(kit_step_tabs_ui(
    "nav", shiny::tabPanel("檔案上傳", value = "upload"), shiny::tabPanel("串接", value = "join"),
    groups = list(kit_navgroup("準備", c(upload = "檔案上傳")), kit_navgroup("做出資料", c(join = "串接")))
  ))
  expect_match(grouped, "data-tabset=\"nav-tabs\"", fixed = TRUE)
  expect_match(grouped, "class=\"nav-link active\" href=\"#\" data-kit-tab=\"upload\"", fixed = TRUE)
  expect_match(grouped, "nav-hidden", fixed = TRUE)
})

test_that("kit_step_tabs_server() turns reactive states into tab states", {
  st <- shiny::reactiveVal(c(data = "success", items = "stale", link = "locked", score = "idle"))
  shiny::testServer(kit_step_tabs_server, args = list(
    states = st, tips = c(link = "先做「② 題目校準」")
  ), {
    r <- session$returned
    s <- r$states()
    by <- setNames(s, vapply(s, `[[`, "", "value"))
    expect_equal(by$data$state, "done")
    expect_equal(by$items$state, "stale")
    expect_equal(by$link$state, "locked")
    expect_equal(by$link$tip, "先做「② 題目校準」")
    expect_equal(by$score$state, "ready")
    expect_equal(by$data$tabset, session$ns("tabs"))
    st(c(data = "warning"))
    session$flushReact()
    expect_equal(r$states()[[1]]$tip, "已完成，但有要注意的地方")
    session$setInputs(tabs = "items")
    expect_equal(r$selected(), "items")
    expect_true(is.function(r$select))
  })
  shiny::testServer(kit_step_tabs_server, args = list(), {
    expect_length(session$returned$states(), 0)
  })
})

test_that("kit_run_gate_ui() has the 還差 slot and a disabled primary button", {
  out <- html(kit_run_gate_ui("gate", "執行串接"))
  expect_match(out, "id=\"gate-ready\" class=\"shiny-html-output\"", fixed = TRUE)
  expect_match(out, "id=\"gate-run\"", fixed = TRUE)
  expect_match(out, "btn-primary", fixed = TRUE)
  expect_match(out, "disabled", fixed = TRUE)
})

test_that("kit_run_gate_server() shows 還差 and only counts clicks when nothing is missing", {
  miss <- shiny::reactiveVal("選 ID 欄")
  shiny::testServer(kit_run_gate_server, args = list(missing = miss), {
    run <- session$returned
    expect_equal(run(), 0L)
    expect_match(as.character(output$ready$html), "還差：選 ID 欄。", fixed = TRUE)
    session$setInputs(run = 1)
    expect_equal(run(), 0L)
    miss(character(0))
    session$flushReact()
    expect_false(any(grepl("還差", as.character(output$ready$html))))
    session$setInputs(run = 2)
    expect_equal(run(), 1L)
    session$setInputs(run = 3)
    expect_equal(run(), 2L)
  })
})

test_that("kit_code_panel_ui() is a collapsed detail around the module's output", {
  out <- html(kit_code_panel_ui("code"))
  expect_match(out, "<details class=\"kit-detail\">\\s*<summary>用 R 怎麼做</summary>")
  expect_match(out, "id=\"code-code\"", fixed = TRUE)
  expect_match(html(kit_code_panel_ui("code", open = TRUE)), "<details class=\"kit-detail\" open>", fixed = TRUE)
})

test_that("kit_code_panel_server() renders kit_code blocks, or one line when there is no code", {
  code <- shiny::reactiveVal(NULL)
  shiny::testServer(kit_code_panel_server, args = list(code = code), {
    expect_match(as.character(output$code$html), "先選資料，這裡才會有程式碼。", fixed = TRUE)
    expect_null(session$returned())
    code(list(tidy = "x <- 1", base = "x = 1"))
    session$flushReact()
    out <- as.character(output$code$html)
    expect_match(out, "<strong>tidyverse 版</strong>", fixed = TRUE)
    expect_match(out, "<strong>base R 版</strong>", fixed = TRUE)
    expect_match(out, "kit-copy", fixed = TRUE)
    codes <- session$returned()
    expect_length(codes, 2)
    expect_s3_class(codes[[1]], "kit_code")
    code(kit_code("y <- 2", "kits 版"))
    session$flushReact()
    expect_match(as.character(output$code$html), "<strong>kits 版</strong>", fixed = TRUE)
  })
})
