# 執行分頁（kit_run_tab_ui()、kit_run_tab_server()）：頁面骨架的順序、id，狀態流

test_that("kit_run_tab_ui(): skeleton order and fixed ids", {
  out <- html(kit_run_tab_ui(
    "stack", "執行疊加",
    guide = kit_tab_guide("把各波資料上下疊起來。", c("按「執行疊加」", "看狀態框與預覽"), "一張長格式的資料。"),
    shiny::uiOutput("stack-source_note"),
    shiny::textInput("stack-x", "設定"),
    result = TRUE, next_step = TRUE
  ))
  ids <- c("kit-guide", "stack-source_note", "stack-x", "stack-settings_line", "stack-ready",
           "stack-run", "stack-status", "stack-result", "stack-downloads",
           "stack-result_details", "stack-code", "stack-next_step")
  pos <- vapply(ids, function(id) regexpr(id, out, fixed = TRUE)[[1]], numeric(1))
  expect_true(all(pos > 0))
  expect_false(is.unsorted(pos))
  expect_match(out, '<button class="btn btn-default action-button btn-primary" disabled id="stack-run" type="button">',
               fixed = TRUE)
  expect_match(out, '<span id="stack-result_details" class="shiny-html-output"></span>',
               fixed = TRUE)
  expect_match(out, "用 R 怎麼做")
})

test_that("kit_run_tab_ui(): gate, slots and the details row are optional", {
  out <- html(kit_run_tab_ui(
    "convert", "開始轉換", shiny::fileInput("convert-file", "檔案"),
    gate = FALSE, result = TRUE, downloads = FALSE, details = FALSE, code = FALSE
  ))
  expect_false(grepl("convert-ready", out))
  expect_false(grepl("disabled", out))
  expect_false(grepl("convert-downloads|kit-details|convert-code", out))
  expect_match(out, 'id="convert-result"')
  # tag 直接放進去（id 不是 result）
  out <- html(kit_run_tab_ui("r", "執行轉換", result = shiny::uiOutput("r-blocked"), code = FALSE))
  expect_match(out, 'id="r-blocked"')
  expect_false(grepl('id="r-result"', out))
  expect_match(out, 'id="r-result_details"')
})

# 一個用骨架寫的小分頁：n 是設定；n = 0 時停下來；n = 99 時要確認
demo_tab <- function(id, guard = NULL) {
  shiny::moduleServer(id, function(input, output, session) {
    tab <- kit_run_tab_server(
      input, output, session, "執行疊加",
      ready = shiny::reactive(if (is.null(input$n)) "選 n"),
      settings = function() if (!is.null(input$n)) paste0(input$n, " 個"),
      stale_on = function() input$n,
      progress = "正在疊加…",
      guard = guard,
      run = function(sure = FALSE) {
        if (identical(input$n, 0)) kit_abort("n 不能是 0。")
        if (identical(input$n, 99) && !sure) kit_abort("很大。", class = "too_big")
        if (identical(input$n, -1)) return(kit_status("error", "有問題要先處理。"))
        if (identical(input$n, -2)) stop("object 'x' not found")
        data.frame(i = seq_len(input$n))
      },
      done = function(res) kit_done_status(paste0("疊加完成：", nrow(res), " 列。")),
      confirm = list(too_big = function(e) kit_status("error", conditionMessage(e))),
      result_ui = function(res) shiny::h5(paste0(nrow(res), " 列")),
      details_ui = function(res) kit_detail("結果預覽", kit_static_table(res)),
      code = function() paste0("x <- seq_len(", input$n, ")")
    )
    tab
  })
}

test_that("kit_run_tab_server(): run → result, status, notification, scroll; stale after a change", {
  notes <- list()
  scrolled <- character()
  testthat::local_mocked_bindings(kit_scroll_to = function(id, session) scrolled <<- c(scrolled, id))
  testthat::local_mocked_bindings(
    showNotification = function(ui, ..., type = "default", session = NULL) {
      notes[[length(notes) + 1]] <<- list(ui = ui, type = type)
      invisible(NULL)
    },
    .package = "shiny"
  )
  shiny::testServer(demo_tab, {
    tab <- session$returned
    expect_match(output$ready$html, "還差：選 n")
    expect_null(tab$result())
    expect_equal(tab$state(), "idle")
    session$setInputs(n = 3)
    expect_null(output$ready$html)
    expect_match(output$settings_line$html, "本次：3 個")
    session$setInputs(run = 1)
    expect_equal(nrow(tab$result()), 3)
    expect_equal(tab$state(), "success")
    expect_match(output$status$html, "【完成】")
    expect_match(output$status$html, "疊加完成：3 列。")
    expect_match(output$result$html, "3 列")
    expect_match(output$result_details$html, "結果預覽")
    expect_match(output$code$html, "x &lt;- seq_len\\(3\\)")
    expect_equal(notes[[1]]$ui, "疊加完成：3 列。")
    expect_equal(scrolled, "status")
    # 改了設定：結果清掉，【要重新執行】
    session$setInputs(n = 4)
    expect_null(tab$result())
    expect_equal(tab$state(), "stale")
    expect_match(output$status$html, "請再按一次「執行疊加」")
    expect_null(output$result$html)
    expect_length(notes, 1)
  })
})

test_that("kit_run_tab_server(): errors, statuses from run(), confirm and guard", {
  notes <- list()
  testthat::local_mocked_bindings(
    showNotification = function(ui, ..., type = "default", session = NULL) {
      notes[[length(notes) + 1]] <<- list(ui = ui, type = type)
      invisible(NULL)
    },
    .package = "shiny"
  )
  shiny::testServer(demo_tab, {
    tab <- session$returned
    session$setInputs(n = 0, run = 1)
    expect_equal(tab$state(), "error")
    expect_match(output$status$html, "n 不能是 0。")
    expect_equal(notes[[1]]$type, "error")
    session$setInputs(n = -2, run = 2)
    expect_match(output$status$html, "執行疊加時發生沒有預期到的問題")
    # run() 傳回狀態：沒有結果
    session$setInputs(n = -1, run = 3)
    expect_null(tab$result())
    expect_match(output$status$html, "有問題要先處理。")
    expect_length(notes, 3)
    # 要確認：狀態框寫原因，不通知；確認以後 run(sure = TRUE)
    session$setInputs(n = 99, run = 4)
    expect_match(output$status$html, "很大。")
    expect_length(notes, 3)
    tab$run(sure = TRUE)
    session$flushReact()
    expect_equal(nrow(tab$result()), 99)
    expect_length(notes, 4)
  })
  shiny::testServer(demo_tab, args = list(guard = function() kit_status("error", "先選檔案。")), {
    session$setInputs(n = 2, run = 1)
    expect_null(session$returned$result())
    expect_match(output$status$html, "先選檔案。")
  })
})
