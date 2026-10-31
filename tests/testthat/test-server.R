test_that("kit_ready_line() writes 還差 with the missing things", {
  out <- html(kit_ready_line(c("至少要 2 個波次的檔案，目前只有 1 個", NA, "", "選 ID 欄"),
                             link = shiny::actionLink("go", "到「檔案上傳」加入檔案 →")))
  expect_match(out, "^<p class=\"kit-ready todo\">\\s*還差：至少要 2 個波次的檔案，目前只有 1 個；選 ID 欄。")
  expect_match(out, "到「檔案上傳」加入檔案 →", fixed = TRUE)
  expect_null(kit_ready_line(character(0)))
  expect_null(kit_ready_line(c(NA, "")))
})

test_that("kit_need_files() says how many files are missing", {
  expect_null(kit_need_files(2L))
  expect_equal(kit_need_files(0L, need = 1L), "先加入檔案")
  expect_equal(kit_need_files(0L), "至少要 2 個波次的檔案，目前還沒有")
  expect_equal(kit_need_files(1L), "至少要 2 個波次的檔案，目前只有 1 個")
})

test_that("kit_run_gate() disables the button and shows 還差 until nothing is missing", {
  s <- fake_session()
  shiny::testServer(function(id) shiny::moduleServer(id, function(input, output, session) {
    n_files <- shiny::reactiveVal(1L)
    session$userData$n_files <- n_files
    kit_run_gate(s, output, shiny::reactive(kit_need_files(n_files())),
                 link = function() shiny::actionLink("go", "加入檔案 →"))
  }), {
    session$flushReact()
    ready <- as.character(output$ready$html)
    expect_match(ready, "kit-ready todo", fixed = TRUE)
    expect_match(ready, "還差：至少要 2 個波次的檔案，目前只有 1 個。", fixed = TRUE)
    expect_match(ready, "加入檔案 →", fixed = TRUE)
    last <- s$inputs[[length(s$inputs)]]
    expect_equal(last$id, "run")
    expect_true(last$message$disabled)

    session$userData$n_files(2L)
    session$flushReact()
    expect_false(any(grepl("還差", as.character(output$ready$html))))
    last <- s$inputs[[length(s$inputs)]]
    expect_false(last$message$disabled)
  })
})

test_that("kit_run_gate() accepts other button and output ids", {
  s <- fake_session()
  shiny::testServer(function(id) shiny::moduleServer(id, function(input, output, session) {
    kit_run_gate(s, output, shiny::reactive("選 ID 欄"), button_id = "go", output_id = "need")
  }), {
    session$flushReact()
    expect_match(as.character(output$need$html), "還差：選 ID 欄。", fixed = TRUE)
    expect_equal(s$inputs[[length(s$inputs)]]$id, "go")
  })
})

test_that("kit_scroll_to() sends kit-scroll only after the flush, with the namespaced id", {
  s <- fake_session("join")
  expect_equal(kit_scroll_to("status", session = s), "join-status")
  expect_length(s$messages, 0)
  expect_length(s$flushed, 1)
  s$run_flushed()
  expect_length(s$messages, 1)
  expect_equal(s$messages[[1]], list(type = "kit-scroll", message = "join-status"))
  expect_null(kit_scroll_to("status", session = NULL))
})

test_that("kit_scroll_to() works inside a module (testServer)", {
  shiny::testServer(function(id) shiny::moduleServer(id, function(input, output, session) {
    shiny::observeEvent(input$run, {
      session$userData$scrolled <- kit_scroll_to("status")
    })
  }), {
    session$setInputs(run = 1)
    expect_equal(session$userData$scrolled, session$ns("status"))
  })
})

test_that("kit_open_details() and kit_unload_guard() send their messages", {
  s <- fake_session("reshape")
  expect_equal(kit_open_details("advanced", session = s), "reshape-advanced")
  expect_equal(s$messages[[1]], list(type = "kit-open-details", message = "reshape-advanced"))
  expect_true(kit_unload_guard(TRUE, session = s))
  expect_false(kit_unload_guard(NA, session = s))
  expect_equal(s$messages[[2]], list(type = "kit-unload-guard", message = TRUE))
  expect_equal(s$messages[[3]], list(type = "kit-unload-guard", message = FALSE))
  expect_null(kit_open_details("x", session = NULL))
})
